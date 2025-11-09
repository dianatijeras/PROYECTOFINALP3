defmodule Mentoria do
  @moduledoc """
  Servicio encargado de gestionar la mentoría dentro de la hackathon.
  """

  @doc """
  Registra un nuevo mentor en el sistema.

  Retorna una tupla con el resultado de la creación.
  """
  @spec registrar_mentor(integer(), String.t()) :: {:ok, Participante.t()} | {:error, String.t()}
  def registrar_mentor(id, nombre) do
    Participante.crear(id, nombre, :mentor)
  end

  @doc """
  Permite que un mentor agregue retroalimentación a un proyecto.
  Devuelve el proyecto actualizado con el comentario agregado.
  """
  @spec dar_retroalimentacion(Participante.t(), Proyecto.t(), String.t()) ::
          {:ok, Proyecto.t()} | {:error, String.t()}
  def dar_retroalimentacion(%Participante{rol: :mentor}, %Proyecto{} = proyecto, comentario) do
    historial = proyecto.historial_retroalimentacion ++ ["Mentor: #{comentario}"]
    {:ok, %{proyecto | historial_retroalimentacion: historial}}
  end

  def dar_retroalimentacion(_, _, _),
    do: {:error, "Solo los mentores pueden dar retroalimentación."}
end
