module TakeEveryIter

struct TakeEvery{T, A} <: AbstractVector{T} 
    range::A
    take::Int
    every::Int
    function TakeEvery(range::A, take::I, every::I) where A <: AbstractArray where I <: Integer
        @assert take <= every
        @assert take >= 0
        new{eltype(A), A}(range, Int(take), Int(every))
    end
end

function Base.iterate(u::TakeEvery)
    it = iterate(u.range)
    if (it === nothing) || (u.take == 0)
        nothing
    else
        it[1], (it[2], 1)
    end
end

function Base.iterate(u::TakeEvery, statein)
    if statein[2] < u.take
        it = iterate(u.range, statein[1])
        if it === nothing
            nothing
        else
            it[1], (it[2], statein[2] + 1)
        end
    else
        it = iterate(u.range, statein[1])
        if it === nothing
            nothing
        else
            it[1], (it[2], statein[2] + 1)
        end
        count = statein[2]
        while true
            if it === nothing
                return nothing
            else
                if count == u.every
                    break
                end
                count = count + 1
                it = iterate(u.range, it[2])
            end
        end
        it[1], (it[2], 1)
    end
end

function Base.length(u::TakeEvery)
    length_range_int = length(u.range)
    (length_range_int ÷ u.every) * u.take + min(length_range_int % u.every, u.take)
end

function Base.first(u::TakeEvery)
    u[1]
end

function Base.collect(u::TakeEvery{T, A}) where T where A
    collect(T, u)
end

function Base.size(u::TakeEvery)
    (length(u),)
end

function Base.getindex(u::TakeEvery, i::Int)
    if 1 <= i <= length(u)
        j = 0
        it = iterate(u)
        while true
            j = j + 1
            if j == i
                return it[1]
            end
            it = iterate(u, it[2])
        end
    else
        throw(BoundsError(u, i))
    end
end

function Base.show(io, mime, u::TakeEvery)
    show(u.range) 
    print(" taking $(u.take) of every $(u.every) elements.")
end

function Base.show(::IO, u::TakeEvery)
    show(u.range) 
    print(" taking $(u.take) of every $(u.every) elements.")
end

export
    TakeEvery

end 
