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

  @doc """
  Actualiza un proyecto existente en la lista de proyectos.
  si el proyecto con el ID especificado no existe, retorna el mismo gestor sin cambios
  """
  @spec actualizacion_proyecto(t(), integer(), map()) :: t()
  def actualizacion_proyecto(%__MODULE__{proyectos: proyectos} = gestor, id, cambios) do
    proyectos_actualizados =
      Enum.map(proyectos, fn proyecto ->
        if proyecto.id == id do
          struct(proyecto, cambios)
        else
          proyecto
        end
      end)

    %{gestor | proyectos: proyectos_actualizados}
  end

  @doc """
  retorna un proyecto por su ID.
  si no existe, devuelve nil
  """
  @spec get_proyecto(t(), integer()) :: proyecto.t() | nil
  def get_proyecto(%__MODULE__{proyectos: proyectos}, id) do
    Enum.find(proyectos, fn proyecto -> proyecto.id == id end)
  end
end
