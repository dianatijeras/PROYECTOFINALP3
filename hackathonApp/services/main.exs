defmodule Main do
  @moduledoc """
  Módulo principal para demostrar el funcionamiento del sistema HackathonApp.
  """

  def run do
    IO.puts("\n Iniciando sistema HackathonApp...\n")

    # === 1. Crear gestor de proyectos ===
    gestor = GestorProyectos.nuevoGestor()
    IO.puts(" Gestor de proyectos creado.\n")

    # === 2. Registrar participantes ===
    {:ok, mentor1} = Participante.crear(1, "Laura Gómez", :mentor)
    {:ok, mentor2} = Participante.crear(2, "Carlos Ruiz", :mentor)

    IO.puts(" Mentores registrados:")
    IO.puts("- #{mentor1.nombre}")
    IO.puts("- #{mentor2.nombre}\n")

    # === 3. Registrar proyectos ===
    gestor =
      GestorProyectos.registrar_proyecto(
        gestor,
        1,
        "EcoTrack",
        "Plataforma para medir huella ecológica",
        "Sostenibilidad"
      )

    gestor =
      GestorProyectos.registrar_proyecto(
        gestor,
        2,
        "Code4All",
        "App educativa para enseñar programación a niños",
        "Educación"
      )

    IO.puts(" Proyectos registrados exitosamente.\n")

    # === 4. Mostrar proyectos ===
    IO.puts(" Lista de proyectos actuales:\n")
    IO.inspect(gestor.proyectos)

    # === 5. Dar retroalimentación a un proyecto ===
    proyecto = GestorProyectos.get_proyecto(gestor, 1)
    {:ok, proyecto_retro} =
      Mentoria.dar_retroalimentacion(mentor1, proyecto, "Excelente enfoque ambiental. ¡Sigan así!")

    IO.puts("\n Retroalimentación agregada a '#{proyecto_retro.nombre}':")
    IO.inspect(proyecto_retro.historial_retroalimentacion)

    # === 6. Enviar mensaje a un equipo ===
    {:ok, mensaje} =
      Comunicacion.enviar_mensaje(
        mentor2.nombre,
        "Equipo Code4All",
        "No olviden preparar la presentación para mañana."
      )

    IO.puts("\n Mensaje enviado:")
    IO.inspect(mensaje)

    # === 7. Mostrar resumen final ===
    IO.puts("\n Resumen del sistema:")
    IO.puts("- Total de proyectos: #{length(gestor.proyectos)}")
    IO.puts("- Retroalimentaciones dadas: 1")
    IO.puts("- Mensajes enviados: 1\n")

    IO.puts(" HackathonApp ejecutado correctamente.\n")
  end
end

# Ejecutar el programa
Main.run()
