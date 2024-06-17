structure Gles3 =
struct
  type buffer = Word32.word
  type shader_type = Word32.word
  type shader = Word32.word
  type program = Word32.word
  type draw_mode = Word32.word
  type update_mode = Word32.word

  (* OpenGL constants used. *)
  val (VERTEX_SHADER, _) =
    _symbol "VERTEX_SHADER" public : ( unit -> shader_type ) * ( shader_type -> unit );
  val (FRAGMENT_SHADER, _) =
    _symbol "FRAGMENT_SHADER" public : ( unit -> shader_type ) * ( shader_type -> unit );
  val (TRIANGLES, _) =
    _symbol "TRIANGLES" public : ( unit -> draw_mode ) * ( draw_mode -> unit );
  val (STATIC_DRAW, _) =
    _symbol "STATIC_DRAW" public : ( unit -> update_mode ) * ( update_mode -> unit );
  val (DYNAMIC_DRAW, _) =
    _symbol "DYNAMIC_DRAW" public : ( unit -> update_mode ) * ( update_mode -> unit );

  (* OpenGL functions used. *)
  val loadGlad = _import "loadGlad" public : unit -> unit;
  val viewport = _import "viewport" public : int * int -> unit;

  val createBuffer = _import "createBuffer" public : unit -> buffer;
  val bindBuffer = _import "bindBuffer" public : buffer -> unit;
  val bufferData =
    _import "bufferData" public : Real32.real vector * int * update_mode -> unit;

  val createShader = _import "createShader" public : shader_type -> shader;
  val compileShader = _import "compileShader" public : shader -> unit;
  val deleteShader = _import "deleteShader" public : shader -> unit;
  val shaderSource = _import "shaderSource" public : shader * string -> unit;

  val vertexAttribPointer =
    _import "vertexAttribPointer" public : int * int -> unit;
  val enableVertexAttribArray =
    _import "enableVertexAttribArray" public : int -> unit;

  val createProgram = _import "createProgram" public : unit -> program;
  val attachShader = _import "attachShader" public : program * shader -> unit;
  val linkProgram = _import "linkProgram" public : program -> unit;
  val useProgram = _import "useProgram" public : program -> unit;
  val deleteProgram = _import "deleteProgram" public : program -> unit;

  val clearColor =
    _import "clearColor" public : Real32.real * Real32.real * Real32.real * Real32.real -> unit;
  val clear = _import "clear" public : unit -> unit;
  val drawArrays = _import "drawArrays" public : draw_mode * int * int -> unit;

  val getUniformLocation =
    _import "getUniformLocation" public : program * string -> int;
  val uniform4f =
    _import "uniform4f" public : int * Real32.real * Real32.real * Real32.real * Real32.real -> unit;
end
