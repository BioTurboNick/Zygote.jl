zerolike(x::Number) = zero(x)
zerolike(x::Tuple) = zerolike.(x)
zerolike(x::T) where T =
  NamedTuple{fieldnames(T)}(map(f -> zerolike(getfield(x, f)), fieldnames(T)))
zerolike(x::Union{Module,Type}) = nothing

# Julia internal definitions

@tangent zerolike(x) = zerolike(x), _ -> zerolike(x)
@tangent one(x) = one(x), _ -> zerolike(x)
@tangent typeof(x) = typeof(x), _ -> nothing
@tangent Core.apply_type(args...) = Core.apply_type(args...), (_...) -> nothing

@tangent tuple(t...) = t, (ṫ...) -> ṫ
@tangent tail(t) = tail(t), ṫ -> tail(ṫ)
@tangent getfield(t, i) = getfield(t, i), (ṫ, _) -> getfield(ṫ, i)
@tangent getproperty(t, i) = getproperty(t, i), ṫ -> getproperty(ṫ, i)

@tangent __new__(T, s...) =
  __new__(T, s...), (_, ṡ...) -> NamedTuple{fieldnames(T)}(ṡ)

# Mathematical definitions

@tangent a + b = a + b, (ȧ, ḃ) -> ȧ + ḃ
@tangent a - b = a - b, (ȧ, ḃ) -> ȧ - ḃ
@tangent a * b = a * b, (ȧ, ḃ) -> ȧ * b + ḃ * a
@tangent -a = -a, ȧ -> -ȧ

@tangent a > b = a > b, (_, _) -> false
@tangent a < b = a < b, (_, _) -> false

@tangent sin(x) = sin(x), ẋ -> ẋ*cos(x)
@tangent cos(x) = cos(x), ẋ -> -ẋ*sin(x)
