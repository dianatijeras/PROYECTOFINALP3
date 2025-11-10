defmodule Mentor do
  @moduledoc """
  Módulo que representa un mentor.
  Incluye persistencia automática en archivo CSV.
  """

  defstruct nombre: "", especialidad: "", equipos_asignados: []

  @adapters_dir Path.expand("../adapters", __DIR__)
  @csv_path Path.join(@adapters_dir, "mentores.csv")

  @type t :: %__MODULE__{
          nombre: String.t(),
          especialidad: String.t(),
          equipos_asignados: [String.t()]
        }

  @doc """
  Crea un nuevo mentor y lo guarda en el archivo CSV.
  """
  @spec crear_mentor(String.t(), String.t(), [String.t()]) :: t()
  def crear_mentor(nombre, especialidad, equipos_asignados \\ []) do
    mentor = %__MODULE__{
      nombre: nombre,
      especialidad: especialidad,
      equipos_asignados: equipos_asignados
    }

    guardar_csv(mentor)
    mentor
  end

  @doc false
  defp guardar_csv(%__MODULE__{} = m) do
    File.mkdir_p!(Path.dirname(@csv_path))
    equipos_str = Enum.join(m.equipos_asignados, ";")
    linea = "#{m.nombre},#{m.especialidad},#{equipos_str}\n"
    File.write!(@csv_path, linea, [:append])
  end

  @doc """
  Lee todos los mentores desde el archivo CSV.
  """
  @spec leer_todos() :: [t()]
  def leer_todos do
    File.mkdir_p!(Path.dirname(@csv_path))

    if File.exists?(@csv_path) do
      File.read!(@csv_path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn linea ->
        [nombre, especialidad, equipos_str] = String.split(linea, ",")
        equipos = if equipos_str == "", do: [], else: String.split(equipos_str, ";", trim: true)

        %__MODULE__{
          nombre: nombre,
          especialidad: especialidad,
          equipos_asignados: equipos
        }
      end)
    else
      []
    end
  end
end

