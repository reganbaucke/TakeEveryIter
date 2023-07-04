module TakeEveryRange

struct TakeEvery{T, A} <: AbstractRange{T} 
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
    first(u.range)
end

function Base.collect(u::TakeEvery{A}) where A <: AbstractVector{T} where T
    collect(T, u)
end

function Base.getindex(u::TakeEvery, i::Int)
    j = 0
    it = iterate(u)
    while true
        j = j + 1
        if it === nothing
            throw(BoundsError)
        elseif j == i
            return it[1]
        end
        it = iterate(u, it[2])
    end
end

function Base.show(io, mime, u::TakeEvery)
    show(io, mime, u.range) 
    print(" taking $(u.take) of every $(u.every) elements.")
end

function Base.show(io, u::TakeEvery)
    show(io, u.range) 
    print(" taking $(u.take) of every $(u.every) elements.")
end

end 
