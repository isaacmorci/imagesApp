class ArchivosController < ApplicationController
Ruta_directorio_archivos = "public/archivos/";
def subir_archivos
   @formato_erroneo = false;
   if request.post?
      archivo = params[:archivo];
      nombre = archivo.original_filename;
      directorio = Ruta_directorio_archivos;
      #Comprueba la extension
      extension = nombre.slice(nombre.rindex("."), nombre.length).downcase;
      if extension == ".bmp" or extension == ".gif" or extension == ".jpg" or extension == ".jpeg" or extension == ".png"
         path = File.join(directorio, nombre);
         resultado = File.open(path, "wb") { |f| f.write(archivo.read) };
         if resultado
            subir_archivo = "ok";
         else
            subir_archivo = "error";
         end
         #Redirige a "archivos" -> "lista_archivos"
         redirect_to :controller => "archivos", :action => "listar_archivos", :subir_archivo => subir_archivo;
      else
         @formato_erroneo = true;
      end
    end
 end

  def listar_archivos
   @archivos = Dir.entries(Ruta_directorio_archivos);
   @mensaje = "";
   if params[:subir_archivo].present?
      if params[:subir_archivo] == "ok";
         @mensaje = "La imagen se ha sido subido exitosamente.";
      else
         @mensaje = "La imagen no ha podido ser subida.";
      end
   end
   if params[:eliminar_archivo].present?
      if params[:eliminar_archivo] == "ok";
         @mensaje = "La imagen se ha sido eliminado exitosamente";
      else
         @mensaje = "La imagen no ha podido ser eliminada.";
      end
   end
  
 end

  def borrar_archivos
	archivo_a_borrar = params[:archivo_a_borrar];
	ruta_al_archivo = Ruta_directorio_archivos + archivo_a_borrar;
	if File.exist?(ruta_al_archivo)
	  resultado = File.delete(ruta_al_archivo);
	else
	  resultado = false;
	end
	if resultado
	  eliminar_archivo = "ok";
	else
	  eliminar_archivo = "error";
	end
	redirect_to :controller => "archivos", :action => "listar_archivos", :eliminar_archivo => eliminar_archivo;
  end
end
