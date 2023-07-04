using TakeEveryIter
using Test

@time a = TakeEvery(4:5:100, 3, 7)
@time b = TakeEvery(a, 3, 5)

@time collect(b)
@time prod(b)