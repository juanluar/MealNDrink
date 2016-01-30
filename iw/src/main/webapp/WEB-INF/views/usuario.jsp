<%@ include file="../fragments/header.jspf" %>
<script type="text/javascript">

function activaBotonEliminacionLocal() {	
	var idLocal = $(this).attr("id").substring("del_".length); 
	var idUsuario=$('#id_usuario').get(0).value;
	$.post( "eliminarLocal",{idUsuario:idUsuario,idLocal:idLocal},function(data){
			$('#TodosLocales').load('usuario?id='+idUsuario+' div#TodosLocales');
	});
}

function activaBotonEliminacionReserva() {	
	var idReserva = $(this).attr("id").substring("delR_".length); 
	var idUsuario=$('#id_usuario').get(0).value;
	$.post( "eliminarReserva",{idUsuario:idUsuario,idReserva:idReserva},function(data){
			$('#TodasReservas').load('usuario?id='+idUsuario+' div#TodasReservas');
	});
}
function activaBotonEliminacionComentario() {	
	var idComentario = $(this).attr("id").substring("delC_".length); 
	var idUsuario=$('#id_usuario').get(0).value;
	$.post( "eliminarComentario",{idUsuario:idUsuario,idComentario:idComentario},function(data){
			$('#TodosComentarios').load('usuario?id='+idUsuario+' div#TodosComentarios');
	});
}
$(function() {
	
	$("body").on("click", ".eliminaLocal", null, activaBotonEliminacionLocal);	
	$("body").on("click", ".eliminaReserva", null, activaBotonEliminacionReserva);
	$("body").on("click", ".eliminaComentario", null, activaBotonEliminacionComentario);	
    $('.qrcode').each(function(i, o) {
        $(o).qrcode({
            "render": "div",
            "size": 100,
            "color": "#3a3",
            "text": $(o).text()
        })
    });
    
    $("#editarUsuario").click(function() {

    	var idUsuario = $("#editId_usuario").val();
    	var redireccion = $("#editRedireccion").val();
    	
    	var nombr = $("#editNameUser").val();
    	var contr = $("#editPwd").val();
    	var e_mail = $("#editEmail").val();
    	var telef = $("#editTel").val();
    	var foto = $("#editfileToUpload").val();
    		
    	$.ajax({
    		url : "${prefix}editarUsuario",
    		type : "POST",
    		data : {
    			editId_usuario : idUsuario,
    			editNameUser : nombr,
    			editPwd : contr,
    			editEmail : e_mail,
    			editTel : telef,
    			editRedireccion : redireccion
    		},
    		error : function() {
    			alert("Ups :(");
    		},
    		success : function(data) {
    			
    			alert(resultadoEditar(data));
    			$("#formEditarFoto").submit();
    			
    			location.href = "${prefix}/iw/usuario?id=${usuario.ID}";
    			

    		}
    	})
    })
})

function resultadoEditar(codigo){
	var respuestaPos = "Se han realizado los siguientes cambios correctamente en: ";
	var respuestaNeg = "Los siguientes cambios no se han podido efectuar: ";
	
    if(codigo.charAt(9) === '1' && codigo.charAt(1) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Apodo";
    }
    else if (codigo.charAt(9) === '1' && codigo.charAt(1) == '1'){
    	respuestaNeg = respuestaNeg + "- Apodo (apodo no v�lido)";
    }
    
    if(codigo.charAt(8) === '1' && codigo.charAt(2) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Contrase�a";
    }
    else if(codigo.charAt(8) === '1' && codigo.charAt(2) == '1'){
    	respuestaNeg = respuestaNeg + "\n" + "- Contrase�a (longitud err�nea)";
    }
    
    if(codigo.charAt(7) === '1' && codigo.charAt(3) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Email";
    }
    else if(codigo.charAt(7) === '1' && codigo.charAt(3) == '1'){
    	respuestaNeg = respuestaNeg + "\n"  + "- Email (email con formato no v�lido)";
    }
    
    if(codigo.charAt(6) === '1' && codigo.charAt(4) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Tel�fono";
    }
    else if(codigo.charAt(6) === '1' && codigo.charAt(4) == '1'){
    	respuestaNeg = respuestaNeg + "\n" + "- Tel�fono (tel�fono con formato no v�lido)";
    }
    
    if(codigo === "1000000000"){
    	return "No ha habido cambios";
    }
    else{
    	if(respuestaPos == "Se han realizado los siguientes cambios correctamente en: " && respuestaNeg != "Los siguientes cambios no se han podido efectuar: ")
    		return respuestaNeg;
    	else if(respuestaNeg == "Los siguientes cambios no se han podido efectuar: " && respuestaPos != "Se han realizado los siguientes cambios correctamente en: ")
    		return respuestaPos;
    	else
    		return respuestaPos + "\n" + respuestaNeg;
    }
   
}

$("body").on( "keyup", "#editNameUser", null, function(){
	var campo = $("#editNameUser");
	var nombr = $("#editNameUser").val();
	
	$.ajax({
		url : "${prefix}disponibilidadApodo",
		type : "POST",
		data : {
			apodo : nombr
		},
		error : function() {
			alert("Ups :(");
		},
		success : function(data) {
			if(data === "libre"){
				campo.css("border-color", "green");
			}
			else if(data === "ocupado"){
				campo.css("border-color", "red");
			}
	
		}
	})
} )

</script>
<section id="feature" class="transparent-bg">
            <div class="container">
                <div class="center">
                     <h2>${usuario.nombre}</h2>
                </div>
                <div class="row">
                    <div class="features">
                        <div class="col-md-4 col-sm-4">
                            <img src="usuariosFoto?id=${usuario.ID}.jpg" height="275" width="275">                              
							<input hidden="submit" id="id_usuario" value="${usuario.ID}" /> 
							<h3>Mis datos</h3>
							<p>${usuario.email}</p>
							<p>${usuario.telefono}</p>											
						</div>
                    </div><!--/.col-md-4-->

                    <div class="col-md-6 col-sm-6">
                       
							<ul class="nav nav-tabs">
								<li class="active"><a href="#reservas" data-toggle="tab">Mis reservas</a></li>
								<li><a href="#locales" data-toggle="tab">Mis locales</a></li>
								<li><a href="#opiniones" data-toggle="tab">Mis opiniones</a></li>
								<li><a href="#editar" data-toggle="tab">Mis datos</a></li>
							</ul>						
									
							<div class="tab-content">
								<div class="tab-pane fade in active" id="reservas">
									<c:forEach items="${usuario.reservas}" var="i">
										<div class="media">
											<div class="pull-left">
												<img class="media-object" WIDTH=178 HEIGHT=150 src="ofertasFoto?id=${i.oferta.ID}">
											</div>										
											<div class="media-body">
												<h4 class="media-heading">Reserva #1</h4>
												<p>${i.oferta.nombre}</p>
												
												 <div class="qrcode">${i.codigoQr}</div>
												
												<button id="delO_${i.oferta.ID}" type="submit" class="btn btn-default"><span class="glyphicon glyphicon-trash"></span> Eliminar</button>
											</div>
										</div>	
										</c:forEach>
								</div>	
								
								<div class="tab-pane fade" id="locales">
								<div class="media">
								  	<button type="submit" id="AddNuevoLocal"class="btn btn-default" data-toggle="modal" data-target="#ModalAddLocal"><span class="glyphicon glyphicon-plus"></span> A�adir nuevo local</button>
								  	<br></br>
								</div>
								
								<!-- Modal Add Local-->
						<div class="modal fade" id="ModalAddLocal" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        <h4 class="modal-title" id="myModalLabel"> A�adir un nuevo local</h4>
						      </div>
						      <div class="modal-body">
								<form role="form" method="POST" enctype="multipart/form-data" action="nuevoLocal">
								<input hidden="submit" name="id_usuario" value="${usuario.ID}" />	
								<input hidden="submit" name="redireccion" value="usuario" />	
								  <div class="form-group">
									<label for="name">Nombre:</label>
									<input type="text" class="form-control" id="name" name="name" placeholder="Introduce un nuevo nombre">
								  </div>
								  <div class="form-group">
									<label for="timeBusiness">Horario:</label>
									<input type="time" class="form-control" id="timeBusiness" name="timeBusiness" placeholder="Introduce un nuevo horario">
								  </div>
								  <div class="form-group">
									<label for="dir">Direcci�n:</label>
									<input type="text" class="form-control" id="dir" name="dir" placeholder="Introduce una nueva direccion">
								  </div>
								  <div class="form-group">
									<label for="email">Email:</label>
									<input type="email" class="form-control" id="email" name="email" placeholder="Introduce un nuevo email">
								  </div>
								  <div class="form-group">
									<label for="tel">Tel�fono:</label>
									<input type="tel" class="form-control" id="tel" name="tel" placeholder="Introduce un nuevo telefono">
								  </div>
								  <div class="form-group">
									<label for="tags">Tags iniciales:</label>
									<input type="text" class="form-control" id="tags" name="tags" placeholder="Introduce unos tags iniciales">
								  </div>
								  <div class="form-group">
									<label for="file">Imagen de perfil:</label>
									<input type="file" name="fileToUpload" accept="image/*" id="fileToUpload">											
								  </div>
								  <div class="modal-footer">						      	 
									  <button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-send"></span> Enviar</button>
									  <button type="submit" class="btn" data-dismiss="modal">Cancel</button>
							      </div>
							      </form>											
						      </div>
							      
						      
						    </div>
						  </div>
						</div>     
						<!-- End Modal Add Local-->
								<div id="TodosLocales" class="TodosLocales">
										<c:forEach items="${usuario.locales}" var="i">
										<div class="media">
											<div class="pull-left">
												<img class="media-object" WIDTH=178 HEIGHT=150 src="localesFoto?id=${i.ID}.jpg" >
											</div>										
											<div class="media-body">
												<h4 class="media-heading">${i.nombre}</h4>
												<p>Direcci�n:${i.direccion }</p>
												<p>Horario: ${i.horario }</p>								
												<p>Puntuaci�n: ${i.puntuacion }</p>
												<button type="submit" id="edit_${i.ID}" value="${i}" data-toggle="modal" data-target="#ModalEditLocal" ><span class="glyphicon glyphicon-pencil"></span> Editar</button>
												<button id="del_${i.ID}" class="eliminaLocal"><span class="glyphicon glyphicon-trash"></span>Eliminar</button>
											</div>
										</div>	
										</c:forEach>
									</div>												
								</div>
        				<!-- Modal Edit Local-->
						<div class="modal fade" id="ModalEditLocal" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        <h4 class="modal-title" id="myModalLabel"> Editar local</h4>
						      </div>
						      <div class="modal-body">
								<form role="form" method="POST" enctype="multipart/form-data" action="nuevoLocal">
								<input hidden="submit" name="redireccion" value="usuario" />
								  <div class="form-group">
									<label for="name">Nombre:</label>
									<input type="text" class="form-control" id="name" name="name" placeholder="Introduce un nuevo nombre">
								  </div>
								  <div class="form-group">
									<label for="timeBusiness">Horario:</label>
									<input type="time" class="form-control" id="timeBusiness" name="timeBusiness" placeholder="Introduce un nuevo horario">
								  </div>
								  <div class="form-group">
									<label for="dir">Direcci�n:</label>
									<input type="text" class="form-control" id="dir" name="dir" placeholder="Introduce una nueva direccion">
								  </div>
								  <div class="form-group">
									<label for="email">Email:</label>
									<input type="email" class="form-control" id="email" name="email" placeholder="Introduce un nuevo email">
								  </div>
								  <div class="form-group">
									<label for="tel">Tel�fono:</label>
									<input type="tel" class="form-control" id="tel" name="tel" placeholder="Introduce un nuevo telefono">
								  </div>
								  <div class="form-group">
									<label for="tags">Tags iniciales:</label>
									<input type="text" class="form-control" id="tags" name="tags" placeholder="Introduce unos tags iniciales">
								  </div>
								  <div class="form-group">
									<label for="file">Imagen de perfil:</label>
									<input type="file" name="fileToUpload" accept="image/*" id="fileToUpload">											
								  </div>
								  <div class="modal-footer">						      	 $("#formRegis").submit();
									  <button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-send"></span> Enviar</button>
									  <button type="submit" class="btn" data-dismiss="modal">Cancel</button>
							      </div>	
							      </form>											
						      </div>
							      
						      
						    </div>
						  </div>
						</div>     
						<!-- End Modal Edit Local-->								
									
												
								<div class="tab-pane fade" id="opiniones">
									<div id="TodosComentarios" class="TodosComentarios">	
											<c:forEach items="${usuario.comentarios}" var="i">
												<div class="media">
												<div class="pull-left">
													<img class="media-object" WIDTH=178 HEIGHT=150 src="localesFoto?id=${i.ID}.jpg" >
												</div>
												<div class="media-body">
													<h4 class="media-heading">Comentario</h4>
													<p>${i.texto}</p>
													<button id="delC_${i.ID}" class="eliminaComentario"><span class="glyphicon glyphicon-trash"></span> Eliminar</button>
												</div>
												</div>
											</c:forEach>			
									</div>
								</div>
								
								<div class="tab-pane fade" id="editar">
									
										<input hidden="submit" name="editId_usuario" id="editId_usuario" value="${usuario.ID}" />
										<input hidden="submit" name="editRedireccion" id="editRedireccion" value="usuario" />
										<div class="form-group">
											<label for="name">Nombre:</label>
											<input type="text" class="form-control" name="editNameUser" id="editNameUser" value="${usuario.nombre }">
										</div>
										<div class="form-group">
											<label for="pwd">Contrase�a:</label>
											<input type="password" class="form-control" name="editPwd" id="editPwd" value="">
										</div>
										<div class="form-group">
											<label for="email">Email:</label>
											<input type="email" class="form-control" name="editEmail" id="editEmail" value="${usuario.email }">
										</div>
										<div class="form-group">
											<label for="tel">Tel�fono:</label>
											<input type="tel" class="form-control" name="editTel" id="editTel" value="${usuario.telefono }">
										</div>
										  
										  
										<form id="formEditarFoto" name="formEditarFoto" role="form" method="POST" enctype="multipart/form-data" action="editarUsuarioFoto">
											  
											<div class="form-group">
												<input hidden="submit" name="editId_usuario" id="editId_usuario" value="${usuario.ID}">
												<label for="file">Imagen de perfil:</label>
												<input type="file" name="editFileToUpload" accept="image/*" id="editFileToUpload">											
											</div>
										</form>  										  
										<br>
										 <button id="editarUsuario" name="editarUsuario" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> Editar</button>
																				
																	
								</div>
							</div><!--tab content-->
						
					</div><!--/.services-->
            </div><!--/.row--> 
            </div>
        </section>
<%@ include file="../fragments/footer.jspf" %>
        