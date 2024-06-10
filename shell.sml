structure Shell = 
struct
  fun loop window =
    if not (Glfw.windowShouldClose window) then
      let
        val _ = Gles3.clearColor (0.1, 0.1, 0.1, 0.1)
        val _ = Gles3.clear ()
        val _ = Glfw.pollEvents ()
        val _ = Glfw.swapBuffers window
      in
        loop window
      end
    else
      Glfw.terminate ()

  fun main() =
    let
      val _ = Glfw.init()
      val _ = Glfw.windowHint (Glfw.CONTEXT_VERSION_MAJOR (), 3)
      val _ = Glfw.windowHint (Glfw.DEPRECATED (), Glfw.FALSE ())
      val _ = Glfw.windowHint (Glfw.SAMPLES (), 4)
      val window = Glfw.createWindow (500, 500, "MLton - Pong Wars")
      val _ = Glfw.makeContextCurrent window
      val _ = Gles3.loadGlad ()
    in
      loop window
    end
end

val _ = Shell.main ()
