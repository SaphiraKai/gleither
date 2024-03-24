import gleam/option.{type Option, None, Some}

/// Monad representing a Left or Right
pub type Either(left, right) {
  /// left
  Left(val: left)
  /// right
  Right(val: right)
}

/// Returns True if the supplied value is a Left
pub fn is_left(either: Either(left, right)) -> Bool {
  case either {
    Left(_) -> True
    Right(_) -> False
  }
}

/// Returns True if the supplied value is a Right
pub fn is_right(either: Either(left, right)) -> Bool {
  !is_left(either)
}

/// get the value of a Left or None
pub fn get(either: Either(left, right)) -> Option(left) {
  case either {
    Left(val) -> Some(val)
    Right(_) -> None
  }
}

/// get the value of a Right or None
pub fn get_right(either: Either(left, right)) -> Option(right) {
  case either {
    Right(val) -> Some(val)
    Left(_) -> None
  }
}

/// get the value of a Left or default
pub fn get_with_default(either: Either(left, right), default: left) -> left {
  either
  |> get()
  |> option.unwrap(default)
}

/// get the value of a Right or default
pub fn get_right_with_default(
  either: Either(left, right),
  default: right,
) -> right {
  either
  |> get_right()
  |> option.unwrap(default)
}

/// apply a function to the Left or preserve the Right
pub fn map(
  either: Either(left, right),
  func: fn(left) -> new,
) -> Either(new, right) {
  case either {
    Left(l) -> Left(func(l))
    Right(r) -> Right(r)
  }
}

/// apply a function to the Right or preserve the Left
pub fn map_right(
  either: Either(left, right),
  func: fn(right) -> new,
) -> Either(left, new) {
  case either {
    Right(r) -> Right(func(r))
    Left(l) -> Left(l)
  }
}

/// map either potential value
pub fn full_map(
  either: Either(left, right),
  left_func: fn(left) -> new_left,
  right_func: fn(right) -> new_right,
) -> Either(new_left, new_right) {
  either
  |> map(left_func)
  |> map_right(right_func)
}

/// flatten a nested Left
pub fn flatten(
  either: Either(Either(left, right), right),
) -> Either(left, right) {
  case either {
    Left(inner) -> inner
    Right(r) -> Right(r)
  }
}

/// flatten a nested Right
pub fn flatten_right(
  either: Either(left, Either(left, right)),
) -> Either(left, right) {
  case either {
    Right(inner) -> inner
    Left(l) -> Left(l)
  }
}

/// map and flatten a Left
pub fn flat_map(
  either: Either(left, right),
  func: fn(left) -> Either(left, right),
) -> Either(left, right) {
  either
  |> map(func)
  |> flatten
}

/// flat_map either potential value
pub fn full_flat_map(
  either: Either(left, right),
  left_func: fn(left) -> Either(left, right),
  right_func: fn(right) -> Either(left, right),
) -> Either(left, right) {
  either
  |> flat_map(left_func)
  |> flat_map_right(right_func)
}

/// map and flatten a Right
pub fn flat_map_right(
  either: Either(left, right),
  func: fn(right) -> Either(left, right),
) -> Either(left, right) {
  either
  |> map_right(func)
  |> flatten_right
}

/// Convert a Left to a Right and vice versa
pub fn swap(either: Either(left, right)) -> Either(right, left) {
  case either {
    Right(r) -> Left(r)
    Left(l) -> Right(l)
  }
}
