defmodule Equipo do
  @moduledoc """
  Módulo que representa un equipo dentro de la hackathon.
  Incluye persistencia automática en archivo CSV.
  """

  defstruct id: "", nombre: "", categoria: "", lista_participantes: [], id_proyecto: ""

  @adapters_dir Path.expand("../adapters", __DIR__)
  @csv_path Path.join(@adapters_dir, "equipos.csv")

  @doc """
  Crea un nuevo equipo y lo guarda en el archivo CSV.
  """
  def crear_equipo(id, nombre, categoria, lista_participantes, id_proyecto) do
    equipo = %__MODULE__{
      id: id,
      nombre: nombre,
      categoria: categoria,
      lista_participantes: lista_participantes,
      id_proyecto: id_proyecto
    }

    guardar_csv(equipo)
    equipo
  end

  def agregar_participante(equipo, participante) do
    %{equipo | lista_participantes: [participante | equipo.lista_participantes]}
  end

  defp guardar_csv(%__MODULE__{} = e) do
    File.mkdir_p!(Path.dirname(@csv_path))
    # Guardar participantes como strings separados por ;
    participantes_str = Enum.join(e.lista_participantes, ";")
    linea = "#{e.id},#{e.nombre},#{e.categoria},#{participantes_str},#{e.id_proyecto}\n"
    File.write!(@csv_path, linea, [:append])
  end

  def leer_todos do
    File.mkdir_p!(Path.dirname(@csv_path))

    if File.exists?(@csv_path) do
      File.read!(@csv_path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn linea ->
        [id, nombre, categoria, participantes_str, id_proyecto] = String.split(linea, ",", parts: 5)
        participantes = String.split(participantes_str, ";", trim: true)
        %__MODULE__{
          id: id,
          nombre: nombre,
          categoria: categoria,
          lista_participantes: participantes,
          id_proyecto: id_proyecto
        }
      end)
    else
      []
    end
  end
end

