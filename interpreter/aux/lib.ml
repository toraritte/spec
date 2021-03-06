module Fun =
struct
  let rec repeat n f x =
    if n = 0 then () else (f x; repeat (n - 1) f x)
end

module List =
struct
  let rec make n x =
    if n = 0 then [] else x :: make (n - 1) x

  let rec table n f = table' 0 n f
  and table' i n f =
    if i = n then [] else f i :: table' (i + 1) n f

  let rec take n xs =
    match n, xs with
    | 0, _ -> []
    | n, x::xs' when n > 0 -> x :: take (n - 1) xs'
    | _ -> failwith "take"

  let rec drop n xs =
    match n, xs with
    | 0, _ -> xs
    | n, _::xs' when n > 0 -> drop (n - 1) xs'
    | _ -> failwith "drop"

  let rec last = function
    | x::[] -> x
    | _::xs -> last xs
    | [] -> failwith "last"

  let rec split_last = function
    | x::[] -> [], x
    | x::xs -> let ys, y = split_last xs in x::ys, y
    | [] -> failwith "split_last"

  let rec index_of x xs = index_of' x xs 0
  and index_of' x xs i =
    match xs with
    | [] -> None
    | y::xs' when x = y -> Some i
    | y::xs' -> index_of' x xs' (i+1)
end

module List32 =
struct
  let rec length xs = length' xs 0l
  and length' xs n =
    match xs with
    | [] -> n
    | _::xs' when n < Int32.max_int -> length' xs' (Int32.add n 1l)
    | _ -> failwith "length"

  let rec nth xs n =
    match n, xs with
    | 0l, x::_ -> x
    | n, _::xs' when n > 0l -> nth xs' (Int32.sub n 1l)
    | _ -> failwith "nth"

  let rec take n xs =
    match n, xs with
    | 0l, _ -> []
    | n, x::xs' when n > 0l -> x :: take (Int32.sub n 1l) xs'
    | _ -> failwith "take"

  let rec drop n xs =
    match n, xs with
    | 0l, _ -> xs
    | n, _::xs' when n > 0l -> drop (Int32.sub n 1l) xs'
    | _ -> failwith "drop"
end

module Array32 =
struct
  let make n x =
    if n < 0l || Int64.of_int32 n > Int64.of_int max_int then
      raise (Invalid_argument "Array32.make");
    Array.make (Int32.to_int n) x

  let length a = Int32.of_int (Array.length a)

  let index_of_int32 i =
    if i < 0l || Int64.of_int32 i > Int64.of_int max_int then -1 else
    Int32.to_int i

  let get a i = Array.get a (index_of_int32 i)
  let set a i x = Array.set a (index_of_int32 i) x
  let blit a1 i1 a2 i2 n =
    Array.blit a1 (index_of_int32 i1) a2 (index_of_int32 i2) (index_of_int32 n)
end

module Bigarray =
struct
  open Bigarray

  module Array1_64 =
  struct
    let create kind layout n =
      if n < 0L || n > Int64.of_int max_int then
        raise (Invalid_argument "Bigarray.Array1_64.create");
      Array1.create kind layout (Int64.to_int n)

    let dim a = Int64.of_int (Array1.dim a)

    let index_of_int64 i =
      if i < 0L || i > Int64.of_int max_int then -1 else
      Int64.to_int i

    let get a i = Array1.get a (index_of_int64 i)
    let set a i x = Array1.set a (index_of_int64 i) x
    let sub a i n = Array1.sub a (index_of_int64 i) (index_of_int64 n)
  end
end

module Option =
struct
  let get o x =
    match o with
    | Some y -> y
    | None -> x

  let map f = function
    | Some x -> Some (f x)
    | None -> None

  let app f = function
    | Some x -> f x
    | None -> ()
end

module Int =
struct
  let is_power_of_two x =
    if x < 0 then failwith "is_power_of_two";
    x <> 0 && (x land (x - 1)) = 0
end

module String =
struct
  let breakup s n =
    let rec loop i =
      let len = min n (String.length s - i) in
      if len = 0 then [] else String.sub s i len :: loop (i + len)
    in loop 0
end
