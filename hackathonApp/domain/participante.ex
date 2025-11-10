defmodule Participante do
  @moduledoc """
  Módulo que representa a un participante dentro de la hackathon.
  Incluye persistencia automática en archivo CSV.
  """

  defstruct [:id, :nombre, :rol, :id_equipo]

  @roles_validos [:developer, :diseñador, :mentor, :organizador]

  # Ruta absoluta a la carpeta adapters
  @adapters_dir Path.expand("../adapters", __DIR__)
  @csv_path Path.join(@adapters_dir, "participantes.csv")

  @type rol :: :developer | :diseñador | :mentor | :organizador
  @type t :: %__MODULE__{
          id: integer(),
          nombre: String.t(),
          rol: rol(),
          id_equipo: integer() | nil
        }

  @doc """
  Crea un nuevo participante y lo guarda en el archivo CSV.
  """
  @spec crear(integer(), String.t(), rol()) :: {:ok, t()} | {:error, String.t()}
  def crear(id, nombre, rol) when rol in @roles_validos do
    participante = %__MODULE__{id: id, nombre: nombre, rol: rol, id_equipo: nil}
    guardar_csv(participante)
    {:ok, participante}
  end

  def crear(_, _, rol),
    do: {:error, "Rol inválido: #{inspect(rol)}. Roles válidos: #{@roles_validos}"}

  @doc """
  Guarda un participante en el archivo CSV.
  """
  defp guardar_csv(%__MODULE__{} = p) do
    File.mkdir_p!(Path.dirname(@csv_path))

    linea = "#{p.id},#{p.nombre},#{p.rol},#{p.id_equipo}\n"
    File.write!(@csv_path, linea, [:append])
  end

  @doc """
  Lee todos los participantes del archivo CSV.
  """
  @spec leer_todos() :: [t()]
  def leer_todos do
    File.mkdir_p!(Path.dirname(@csv_path))

    if File.exists?(@csv_path) do
      File.read!(@csv_path)
      |> String.split("\n", trim: true)
      |> Enum.map(fn linea ->
        [id, nombre, rol, id_equipo] = String.split(linea, ",")
        %__MODULE__{
          id: String.to_integer(id),
          nombre: nombre,
          rol: String.to_atom(rol),
          id_equipo: if(id_equipo == "nil" or id_equipo == "", do: nil, else: String.to_integer(id_equipo))
        }
      end)
    else
      []
    end
  end
end
