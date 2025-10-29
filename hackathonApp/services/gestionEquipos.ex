defmodule GestionEquipos do
  alias Equipo
  alias Participante

 @doc """
  Estado interno (solo para esta ejecución)
 """
  defp obtener_lista_equipos do
    Process.get(:equipos, [])
  end

  defp guardar_lista_equipos(nueva_lista) do
    Process.put(:equipos, nueva_lista)
  end

  @doc """
  Crea un nuevo participante.
  """
  def crear_participante(nombre) do
    Participante.crear(nombre)
  end

  @doc """
  Crea un nuevo equipo con un participante inicial.
  """
  def crear_equipo(nombre, categoria, participante) do
    equipo = Equipo.crear(nombre, categoria, participante)
    Agent.update(__MODULE__, fn equipos -> [equipo | equipos] end)
    IO.puts("Equipo '#{nombre}' creado en la categoría '#{categoria}'.")
    equipo
  end

  @doc """
  Permite que un participante se una a un equipo existente por nombre.
  """
  def unirse_equipo(nombre_equipo, participante) do
    Agent.get_and_update(__MODULE__, fn equipos ->
      {equipo_actualizado, nuevos_equipos} =
        Enum.map_reduce(equipos, nil, fn equipo, _ ->
          if equipo.nombre == nombre_equipo do
            nuevo = Equipo.agregar_participante(equipo, participante)
            {nuevo, nuevo}
          else
            {equipo, nil}
          end
        end)

      if equipo_actualizado do
        IO.puts("#{participante.nombre} se unió al equipo #{nombre_equipo}.")
        {equipo_actualizado, nuevos_equipos}
      else
        IO.puts("No se encontró el equipo '#{nombre_equipo}'.")
        {nil, equipos}
      end
    end)
  end

  @doc """
  funcion qu elista los equipos
  """
  def lista_equipos do
    equipos = obtener_lista_equipos()
    Enum.each(equipos, fn e ->
      IO.puts("#{e.nombre} (#{e.categoria}) → #{Enum.map_join(e.lista_participantes, ", ", & &1.nombre)}")
    end)
    equipos
  end
end
