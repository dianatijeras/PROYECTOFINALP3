defmodule GestorProyectos do
  @moduledoc """
  Servicio encargado de gestior los proyectos dentro de la hackathon
  """

  alias Proyecto

  desfstruct proyectos: []

  @type t :: %__MODULE__{
          proyectos: [Proyecto.t()]
  }

  @doc """
  crea una nueva instancia del gestor con la lista de proyectos vacia
  """
  @spec nuevoGestor() :: t()
  def nuevoGestor, do: %__MODULE__{proyectos: []}

  @doc """
  Registra un nuevo proyecto usando el modulo del dominio proyecto
  retorna el gestor actualizado con el proyecto agregado
  """
  @spec registrar_proyecto(t(), integer(), String.t(), String.t, String.t()) :: t()
  def registrar_proyecto(%__MODULE__{proyectos: proyectos} = gestor, id, nombre, descripcion, categoria) do
    nuevo_proyecto = Proyecto.nuevoProyecto(id, nombre, descripcion, categoria)
    %{gestor | proyectos: proyectos ++ [nuevo_proyecto]}
  end

  
end
