# See http://a-coda.tumblr.com/
 
import Base.&, Base.|, Base.-, Base.!
 
index = Dict()
 
tokenize(text) = map(lowercase, split(text))
 
lookup(terms) = mapreduce(token -> get(index, token, Set()), intersect, tokenize(terms))
 
all() = reduce(union, values(index))
 
function index_file(file)
    for word in tokenize(open(readall, file))
        push!(get!(index, word, Set()), file)
    end
end
 
function walk_directory(fn, directory)
    for file in readdir(directory)
        path = joinpath(directory, file)
        if isdir(path)
            walk_directory(fn, path)
        else
            fn(path)
        end
    end
end
 
function index_directory(directory, extension="")
    walk_directory(directory) do file
        if (endswith(file, extension)) 
            index_file(file)
        end
    end
end
 
macro s_str(terms)
    lookup(terms)
end
 
Base.&(hits1::Set, hits2::Set) = intersect(hits1, hits2)
Base.|(hits1::Set, hits2::Set) = union(hits1, hits2)
     -(hits1::Set, hits2::Set) = setdiff(hits1, hits2)
     !(hits::Set)              = all() - hits
