defmodule Proyecto do
  @moduledoc """
  Módulo que representa un proyecto dentro de la hackathon.
  Incluye persistencia automática en archivo CSV.
  """

  defstruct [:id, :nombre, :descripcion, :categoria, estado: "en desarrollo", historial_retroalimentacion: []]

  @adapters_dir Path.expand("../adapters", __DIR__)
  @csv_path Path.join(@adapters_dir, "proyectos.csv")

  @type t :: %__MODULE__{
          id: integer(),
          nombre: String.t(),
          descripcion: String.t(),
          categoria: String.t(),
          estado: String.t(),
          historial_retroalimentacion: [String.t()]
        }

  @doc """
  Crea un nuevo proyecto y lo guarda en el archivo CSV.
  """
  def nuevoProyecto(id, nombre, descripcion, categoria) do
    proyecto = %__MODULE__{
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria
    }

    guardar_csv(proyecto)
    proyecto
  end

  @doc false
  defp guardar_csv(%__MODULE__{} = p) do
    File.mkdir_p!(Path.dirname(@csv_path))
    # Guardamos cada campo tal cual, sin manipular comas
    linea = "#{p.id},#{p.nombre},#{p.descripcion},#{p.categoria},#{p.estado}\n"
    File.write!(@csv_path, linea, [:append])
  end

  @doc """
  Lee todos los proyectos registrados desde el CSV.
  Soporta descripciones con comas.
  """
  def leer_todos do
    File.mkdir_p!(Path.dirname(@csv_path))

    if File.exists?(@csv_path) do
      File.read!(@csv_path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn linea ->
        # Separar exactamente en 5 partes para que las comas en descripción no rompan el split
        [id, nombre, descripcion, categoria, estado] = String.split(linea, ",", parts: 5)
        %__MODULE__{
          id: String.to_integer(id),
          nombre: nombre,
          descripcion: descripcion,
          categoria: categoria,
          estado: estado,
          historial_retroalimentacion: []
        }
      end)
    else
      []
    end
  end
end

