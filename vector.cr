require "linalg"

struct Vector3 < LA::AVector3
  define_constants(Vector3)
  define_vector_swizzling(3, Vector3)
  define_vector_swizzling(2, Vector2)

  # This one is needed for the “masking” hack
  # with `Vector3::X.yxx` etc.
  define_vector_op(:*)
end

struct Vector2 < LA::AVector2
  define_constants(Vector2)
  define_vector_swizzling(3, Vector3)
  define_vector_swizzling(2, Vector2)
end

