defmodule Main do
  @moduledoc """
  Módulo principal e interactivo del sistema HackathonApp.
  Permite al usuario registrar proyectos, mentores, equipos y enviar retroalimentación desde la terminal.
  """

  def run do
    IO.puts("\n Bienvenido a HackathonApp")
    IO.puts("=================================\n")

    # Cargar equipos desde CSV al iniciar
    loop(%{
      gestor: GestorProyectos.nuevoGestor(),
      mentores: [],
      proyectos: [],
      equipos: Equipo.leer_todos()
    })
  end

  # Bucle principal del menú
  defp loop(state) do
    IO.puts("""
    \n--- Menú Principal ---
    1. Registrar proyecto
    2. Registrar mentor
    3. Crear equipo
    4. Mostrar equipos guardados
    5. Dar retroalimentación a un proyecto
    6. Enviar mensaje a un equipo
    7. Salir
    """)

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "1" -> registrar_proyecto(state)
      "2" -> registrar_mentor(state)
      "3" -> crear_equipo(state)
      "4" -> mostrar_equipos(state)
      "5" -> dar_retroalimentacion(state)
      "6" -> enviar_mensaje(state)
      "7" -> IO.puts("\n ¡Gracias por usar HackathonApp!\n")
      _ ->
        IO.puts(" Opción no válida, intente de nuevo.\n")
        loop(state)
    end
  end

  # Funciones del menú
  defp registrar_proyecto(state) do
    id = IO.gets("ID del proyecto: ") |> String.trim() |> String.to_integer()
    nombre = IO.gets("Nombre del proyecto: ") |> String.trim()
    descripcion = IO.gets("Descripción: ") |> String.trim()
    categoria = IO.gets("Categoría: ") |> String.trim()

    gestor = GestorProyectos.registrar_proyecto(state.gestor, id, nombre, descripcion, categoria)

    IO.puts(" Proyecto '#{nombre}' registrado exitosamente.\n")

    loop(%{state | gestor: gestor, proyectos: gestor.proyectos})
  end

  defp registrar_mentor(state) do
    nombre = IO.gets("Nombre del mentor: ") |> String.trim()
    especialidad = IO.gets("Especialidad: ") |> String.trim()

    mentor = Mentor.crear_mentor(nombre, especialidad, [])
    IO.puts(" Mentor '#{nombre}' registrado.\n")

    loop(%{state | mentores: [mentor | state.mentores]})
  end

  defp crear_equipo(state) do
    id = IO.gets("ID del equipo: ") |> String.trim()
    nombre = IO.gets("Nombre del equipo: ") |> String.trim()
    categoria = IO.gets("Categoría: ") |> String.trim()
    id_proyecto = IO.gets("ID del proyecto asignado: ") |> String.trim()

    participantes =
      IO.gets("Ingrese los nombres de los participantes (separados por coma): ")
      |> String.trim()
      |> String.split(",", trim: true)
      |> Enum.map(&String.trim/1)  # ahora son strings simples

    Equipo.crear_equipo(id, nombre, categoria, participantes, id_proyecto)

    IO.puts(" Equipo '#{nombre}' creado y guardado en CSV.\n")

    loop(%{state | equipos: Equipo.leer_todos()})
  end

  defp mostrar_equipos(state) do
    IO.puts("\n Equipos registrados:\n")

    equipos = Equipo.leer_todos()

    if equipos == [] do
      IO.puts("No hay equipos registrados aún.\n")
    else
      Enum.each(equipos, fn e ->
        IO.puts("- #{e.nombre} (#{e.categoria}) | Proyecto: #{e.id_proyecto}")
        IO.puts("  Participantes: #{Enum.join(e.lista_participantes, ", ")}\n")
      end)
    end

    loop(%{state | equipos: equipos})
  end

  defp dar_retroalimentacion(state) do
    if state.mentores == [] or state.proyectos == [] do
      IO.puts(" Debes tener al menos un mentor y un proyecto registrados.\n")
      loop(state)
    else
      IO.puts("\nMentores disponibles:")
      Enum.each(state.mentores, fn m -> IO.puts("- #{m.nombre} (#{m.especialidad})") end)

      nombre_mentor = IO.gets("Seleccione mentor: ") |> String.trim()
      mentor = Enum.find(state.mentores, fn m -> m.nombre == nombre_mentor end)

      IO.puts("\nProyectos disponibles:")
      Enum.each(state.proyectos, fn p -> IO.puts("- #{p.nombre}") end)

      nombre_proyecto = IO.gets("Seleccione proyecto: ") |> String.trim()
      proyecto = Enum.find(state.proyectos, fn p -> p.nombre == nombre_proyecto end)

      if mentor && proyecto do
        retro = IO.gets("Ingrese la retroalimentación: ") |> String.trim()

        {:ok, proyecto_retro} =
          Mentoria.dar_retroalimentacion(mentor, proyecto, retro)

        IO.puts("\n Retroalimentación agregada a '#{proyecto_retro.nombre}'.\n")
      else
        IO.puts(" Mentor o proyecto no encontrados.\n")
      end

      loop(state)
    end
  end

  defp enviar_mensaje(state) do
    remitente = IO.gets("Nombre del remitente: ") |> String.trim()
    destino = IO.gets("Equipo destino: ") |> String.trim()
    contenido = IO.gets("Mensaje: ") |> String.trim()

    {:ok, mensaje} = Comunicacion.enviar_mensaje(remitente, destino, contenido)

    IO.puts("\n Mensaje enviado a '#{destino}':")
    IO.puts("  \"#{mensaje.mensaje}\" - #{DateTime.utc_now()}\n")

    loop(state)
  end
end

Main.run()

