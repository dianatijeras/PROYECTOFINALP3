defmodule Proyecto do
  @moduledoc """
  Modulo que representa un proyecto dentro de la hackathon
  """
  defstruct [:id, :nombre, :descripcion, :categoria, estado: "en desarrollo", historial_retroalimentacion: []]


  @type t :: %__MODULE__{
    id: integer(),
    nombre: String.t(),
    descripcion: String.t(),
    categoria: String.t(),
    estado: String.t(),
    historial_retroalimentacion: [String.t()]
  }

  @doc """
  Crea un nuevo proyecto con los datos basicos 
  """
  @spec nuevoProyecto(integer(), String.t(), String.t(), String.t()) :: t()
  def nuevoProyecto(id, nombre, descripcion, categoria) do
    %__MODULE__{
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      categoria: categoria
    }
  end

end
