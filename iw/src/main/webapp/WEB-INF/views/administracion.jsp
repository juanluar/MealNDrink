<%@ include file="../fragments/header.jspf" %>
<script type="text/javascript">

function activaBotonEliminacionLocal() {	
	var idLocal = $(this).attr("id").substring("delLocal_".length); 
	$.post( "eliminarLocal",{idLocal:idLocal,csrf: "${csrf_token}"},function(data){
			$('#TodosLocales').load('administracion div#TodosLocales');
	});
}
function activaBotonEliminacionComentario() {	
	var idComentario = $(this).attr("id").substring("delC_".length); 
	var idUsuario=$('#id_usuario').get(0).value;
	$.post( "eliminarComentario",{idUsuario:idUsuario,idComentario:idComentario,csrf: "${csrf_token}"},function(data){
			$('#TodosComentarios').load('usuario?id='+idUsuario+' div#TodosComentarios');
	});
}

function activaBotonEliminacionUsuario() {	
	var idUsuario = $(this).attr("id").substring("delUsuario_".length); 
	$.post( "eliminarUsuario",{idUsuario:idUsuario,csrf: "${csrf_token}"},function(data){
			$('#TodosUsuarios').load('administracion div#TodosUsuarios');
	});
}

function activaBotonAddLocal(){
	var fileToUpload=$('#fileToUpload')[0].files[0];
	var id_local=$('#id_local').get(0).value;
	var name=$('#name').get(0).value;
	var endTime=$('#endTime').get(0).value;
	var cap=$('#cap').get(0).value;
	var description=$('#description').get(0).value;
	
	$.post( "nuevaOferta",{fileToUpload:fileToUpload,id_local:id_local,name:name,endTime:endTime,
		cap:cap,description:description},function(data){
			$('#TodasOfertas').load('comercio_interno?id='+idLocal+' div#TodasOfertas');
	});
	
}

function rellenaDatosEditarModalLocal(){
	var idLocal = $(this).attr("id").substring("edit_".length);
	var res = idLocal.split("/,");
	$("#editNameLocal").attr("value" ,res[0]);
	$("#editHorarioLocal").attr("value" ,res[1]);
	$("#editDirLocal").attr("value" ,res[2]);
	$("#editEmailLocal").attr("value" ,res[3]);
	$("#editTelLocal").attr("value" ,res[4]);
	$("#id_editLocal").attr("value" ,res[5]);
}
function rellenaDatosEditarModalUsuario(){
	var idUsuario = $(this).attr("id").substring("edit_".length);
	var res = idUsuario.split("/,");
	//$('#ModalEditUser').modal('hide');
	$("#editNameUser").attr("value" ,res[0]);
	$("#editEmail").attr("value" ,res[1]);
	$("#editTel").attr("value" ,res[2]);
	$("#editIdUser").attr("value" ,res[3]);
}
function activaBotonRellenaTag() {
	var nombreTagEdit = $(this).attr("id").substring("editTags_".length); 
	var res = nombreTagEdit.split("/");
	$("#nameEditTag").attr("value" ,res[0]);
	$('input[name="id_tag"]').val(res[1]);
}
function activaBotonEditTag() {
	var nombreTagEdit = $("#nameEditTag").attr("value");
	var nombreViejo =$(this).attr("id").substring("editTags_".length); 
	    //Se verifica que el valor del campo este vacio y se eliminan los espacios
	 
	    if (nombreTagEdit.trim() == ''){
	    	$('#TodosTags').load('administracion div#TodosTags');
	    }
		else{
			$.post("editarTag",{nombreTagEdit:nombreTagEdit,nombreViejo:nombreViejo},function(data){
				$('#TodosTags').load('administracion div#TodosTags');
			});	
			
		}
}
$(function() {	
	$("body").on("click", ".eliminaLocal", null, activaBotonEliminacionLocal);	
	$("body").on("click", ".eliminaComentario", null, activaBotonEliminacionComentario);
	$("body").on("click", ".eliminaUsuario", null, activaBotonEliminacionUsuario);
	$("body").on("click", ".anyadirLocal", null, activaBotonAddLocal);
	$("body").on("click", ".rellenaEditTag", null, activaBotonRellenaTag);
	$("body").on("click", ".editaTag", null, activaBotonEditTag);
	$("body").on("click", ".rellenarEditarLocal", null, rellenaDatosEditarModalLocal);
	$("body").on("click", ".rellenarEditarUsuario", null, rellenaDatosEditarModalUsuario);
	
	$("#formuEditUsuario").on("submit", function(a){
        a.preventDefault();
        var f = $(this);
        var formData = new FormData(document.getElementById("formuEditUsuario"));

        $.ajax({
        	url : "${prefix}editarUsuario",
            type: "post",
            dataType: "html",
            data: formData,
            cache: false,
            contentType: false,
     		processData: false
        })
            .done(function(res){
            	if(res==="Error")
            		alert("Campos err�neos, revisa el formulario");
            	else{
            		$(location).attr('href','administracion');
            		var id_admin=$('#id_admin').get(0).value;
	          		$("#imagenAdmin").removeAttr("src").attr("src", +"/"+id_admin+".jpg");
	          		$('#camposPrincipal').load('administracion div#camposPrincipal');	          		
            	}
            });
    });
	
	
	$("#formEditarModalUser").on("submit", function(a){
        a.preventDefault();
        var f = $(this);
        var formData = new FormData(document.getElementById("formEditarModalUser"));
        $.ajax({
        	url : "${prefix}editarUsuarioModal",
            type: "post",
            dataType: "html",
            data: formData,
            cache: false,
            contentType: false,
     processData: false
        })
            .done(function(res){
            	if(res==="Error")
            		alert("Campos err�neos, revisa el formulario");
            	else
        		if(res === "errorNick")
        			alert("Nick ocupado, elija otro");
            	else{
            		$(location).attr('href','administracion');
            		$('#ModalEditUser').modal('hide');
            		$('#TodosUsuarios').load('administracion div#TodosUsuarios');
            		$("#formEditarModalUser").trigger("reset");            		
            		var idUserImagen=$("#editIdUser").val();
            		$('#imagenUser'+idUserImagen).removeAttr("src").attr("src", +"/"+idUserImagen+".jpg");
    		
            	}
            });
    });
	
	
	$("#formEditarModalLocal").on("submit", function(a){
       a.preventDefault();
        var f = $(this);
        var formData = new FormData(document.getElementById("formEditarModalLocal"));
        $.ajax({
        	url : "${prefix}editarLocal",
            type: "post",
            dataType: "html",
            data: formData,
            cache: false,
            contentType: false,
     processData: false
        })
            .done(function(res){
            	if(res==="Error")
            		alert("Campos err�neos, revisa el formulario");
            	else
        		if(res === "errorNick")
        			alert("Nick ocupado, elija otro");
            	else{
            		
            		$(location).attr('href','administracion');
            		$('#ModalEditLocal').modal('hide');
            		$('#TodosLocales').load('administracion div#TodosLocales');
            		$("#formEditarModalLocal").trigger("reset");            		
            		var idLocalImagen=$("#id_editLocal").val();         	
            		$('#imagenLocal'+idLocalImagen).removeAttr("src").attr("src", +"/"+idLocalImagen+".jpg");
    		
            	}
            });
    });
})

function resultadoEditar(codigo){
	var respuestaPos = "Se han realizado los siguientes cambios correctamente en: ";
	var respuestaNeg = "Los siguientes cambios no se han podido efectuar: ";
	
    if(codigo.charAt(9) === '1' && codigo.charAt(4) == '0'){  //1era columna si ha habido cambios   //2da columna si ha habido error
    	respuestaPos = respuestaPos + "\n" + "- Apodo";
    }
    else if (codigo.charAt(9) === '0' && codigo.charAt(4) == '1'){
    	respuestaNeg = respuestaNeg + "\n" + "- Apodo (apodo no v�lido)";
    }
    
    if(codigo.charAt(8) === '1' && codigo.charAt(3) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Contrase�a";
    }
    else if(codigo.charAt(8) === '0' && codigo.charAt(3) == '1'){
    	respuestaNeg = respuestaNeg + "\n" + "- Contrase�a (longitud err�nea)";
    }
    
    if(codigo.charAt(7) === '1' && codigo.charAt(2) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Email";
    }
    else if(codigo.charAt(7) === '0' && codigo.charAt(2) == '1'){
    	respuestaNeg = respuestaNeg + "\n"  + "- Email (email con formato no v�lido)";
    }
    
    if(codigo.charAt(6) === '1' && codigo.charAt(1) == '0'){
    	respuestaPos = respuestaPos + "\n" + "- Tel�fono";
    }
    else if(codigo.charAt(6) === '0' && codigo.charAt(1) == '1'){
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
    		return respuestaPos + "\n" + "\n" + respuestaNeg;
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

$("body").on( "keyup", "#editNameUserAdmin", null, function(){
	var campo = $("#editNameUserAdmin");
	var nombr = $("#editNameUserAdmin").val();
	
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
                <h2>Administraci�n</h2>                
            </div>

            <div class="row">
                <div class="features">
                    <div class="col-md-5 col-sm-5">
                    <div id="camposPrincipal" >
						<input hidden="submit" id="id_admin" value="${admin.ID}" />
						<img id="imagenAdmin" src="usuariosFoto?id=${admin.ID}.jpg" height="175" width="250">  
						<h3><b>Bienvenido Administrador ${admin.nombre}</b></h3>
						<p>Esta es una p�gina de administraci�n. </br> Aqui podr� hacer todas las gestiones </br> de usuarios y locales, adem�s de editar </br> sus datos personales</p><br/>
						<h3><b>Mis datos</b></h3>
						<p>Telefono: ${admin.telefono}</p>
						<p>Email: ${admin.email}</p>
					</div>
                    </div><!--/.col-md-4-->

                    <div class="col-md-7 col-sm-7">
					<ul class="nav nav-tabs">
					  <li><a href="#lusuarios" data-toggle="tab">Gestionar usuarios</a></li>
					  <li><a href="#llocales" data-toggle="tab">Gestionar locales</a></li>
					  <li><a href="#editarDatos" data-toggle="tab">Mis datos</a></li>
					  <li><a href="#ltags" data-toggle="tab">Mis tags</a></li>
					</ul>

					<div class="tab-content">
						
						 <div class="tab-pane fade in active" id="lusuarios">
						  <div class="media">
						  	<button type="submit" class="btn btn-default" data-toggle="modal" data-target="#ModalAddUser"><span class="glyphicon glyphicon-plus"></span> A�adir nuevo usuario</button>
						  	<br></br>
						  </div>
						  <div id="TodosUsuarios" class="TodosUsuarios" varStatus="status">
							  <c:forEach items="${usuarios}" var="i">
								<div class="media">
									<div class="pull-left">
										<div id="imagenMedia" class="imagenMedia">
											<img id="imagenUser${i.ID}"class="media-object" src="usuariosFoto?id=${i.ID}.jpg"> 
										</div>
									</div>
									<div class="media-body">
										<h4 class="media-heading">${i.nombre} (${i.rol})</h4>
										<p>E-mail: ${i.email}</p>
										<p>Tel�fono: ${i.telefono}</p>																		
										<button type="submit" id="edit_${i.nombre}/,${i.email}/,${i.telefono}/,${i.ID}" value="${i}" class="rellenarEditarUsuario" data-toggle="modal" data-target="#ModalEditUser" ><span class="glyphicon glyphicon-pencil"></span> Editar</button>
										<button id="delUsuario_${i.ID}" class="eliminaUsuario"><span class="glyphicon glyphicon-trash"></span>Eliminar</button>
									</div>
								</div>
								</c:forEach>
							</div>
						</div>
							
		

					  <!-- Modal Add User-->
						<div class="modal fade" id="ModalAddUser" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        <h4 class="modal-title" id="myModalLabel"> A�adir un nuevo usuario</h4>
						      </div>
						      <div class="modal-body">
								<form role="form" method="POST" enctype="multipart/form-data" action="nuevoUsuario">
								  <div class="form-group">
									<label for="name">Nombre:</label>
									<input type="text" class="form-control" required="required" id="name" name="name" placeholder="Introduce un nuevo nombre">
								  </div>
								  <div class="form-group">
									<label for="pwd">Contrase�a:</label>
									<input type="password" class="form-control" required="required" id="pwd" name="pwd" placeholder="Introduce una nueva contrase�a">
								  	<span class="help-block">M�nimo 6 caracteres</span>
								  </div>
								  <div class="form-group">
									<label for="email">Email:</label>
									<input type="email" class="form-control" id="email" required="required" name="email" placeholder="Introduce un nuevo email">
								  </div>
								  <div class="form-group">
									<label for="tel">Tel�fono:</label>
									<input type="tel" class="form-control" id="tel" required="required" name="tel" placeholder="Introduce un nuevo telefono">
								  	<span class="help-block">Por ejemplo: 651651651</span>
								  </div>
								  <div class="form-group">
									<label for="rol">Rol:</label>
									 <select class="form-control" id="rol" name="rol">
									  <option value="user">Usuario</option>
									  <option value="local">Usuario con comercio</option>
									</select>						
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
						<!-- End Modal Add User-->
					   
					   <!-- Modal Edit User-->
						<div class="modal fade" id="ModalEditUser" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        <h4 class="modal-title" id="myModalLabel"> A�adir un nuevo usuario</h4>
						      </div>
						      <div class="modal-body">
								  <form id="formEditarModalUser" role="form" method="POST" enctype="multipart/form-data" > 
								 <input hidden="submit" name="editIdUser" id="editIdUser" />
								 <input type="hidden" name="csrf" value="${r:forJavaScript(csrf_token)}"/>
								  <div class="form-group">
											<label for="name">Nombre:</label>
											<input type="text" class="form-control" name="editNameUser" id="editNameUser">
										</div>
										<div class="form-group">
											<label for="pwd">Contrase�a:</label>
											<input type="password" class="form-control" name="editPwd" id="editPwd" value="">
											<span class="help-block">M�nimo 6 caracteres</span>
										</div>
										<div class="form-group">
											<label for="email">Email:</label>
											<input type="email" class="form-control" name="editEmail" id="editEmail">
										</div>
										<div class="form-group">
											<label for="tel">Tel�fono:</label>
											<input type="tel" class="form-control" name="editTel" id="editTel">
											<span class="help-block">Por ejemplo: 651651651</span>
										</div>
										 
											<div class="form-group">
												<input hidden="submit" name="editId_usuario" id="editId_usuario">
												<label for="file">Imagen de perfil:</label>
												<input type="file" name="editFileToUpload" accept="image/*" id="editFileToUpload">											
											</div>
										
								  <div class="modal-footer">						      	 
									  <button id="editarUsuario" name="editarUsuario"  type="submit" class="btn btn-default"><span class="glyphicon glyphicon-send"></span> Enviar</button>
									  <button type="submit" class="btn" data-dismiss="modal">Cancel</button>
							      </div>
							      </form>									  						  								
						      </div>

						    </div>
						  </div>
						</div>     
					    <!-- End Modal Edit User-->
					  
					  <div class="tab-pane fade" id="llocales">
					  	<div class="media">
					  		<button type="submit" class="btn btn-default" data-toggle="modal" data-target="#ModalAddLocal"><span class="glyphicon glyphicon-plus"></span> A�adir nuevo local</button>
					  		<br></br>
					  	</div>
					  	<div id="TodosLocales" class="TodosLocales">
					  	<c:forEach items="${locales}" var="i">
							<div class="media">
								<div class="pull-left">
									<div id="imagenMedia" class="imagenMedia">
										<img id="imagenLocal${i.ID}" class="media-object" src="localesFoto?id=${i.ID}.jpg"> 
									</div>
								</div>
								<div class="media-body">
									<h4 class="media-heading">${i.nombre}</h4>
									<p>Usuario: ${i.usuario.nombre}</p>																
									<p>Puntuaci�n: ${i.puntuacion}</p>									
									<button type="submit" id="edit_${i.nombre}/,${i.horario}/,${i.direccion}/,${i.email}/,${i.telefono}/,${i.ID}" value="${i}" class="rellenarEditarLocal" data-toggle="modal" data-target="#ModalEditLocal" ><span class="glyphicon glyphicon-pencil"></span> Editar</button>
									<button id="delLocal_${i.ID}" class="eliminaLocal"><span class="glyphicon glyphicon-trash"></span>Eliminar</button>
								</div>
							</div>
							</c:forEach>
						</div>	
						
						<br></br>
						<button type="submit" class="btn btn-default">Anterior</button>
						<button type="submit" class="btn btn-default">Siguiente</button>
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
								<input hidden="submit" name="redireccion" value="administracion" />
								<div class="form-group">								
								<label for="file">Usuario:</label>								
								<select class="form-control" name="id_usuario" id="id_usuario">
									<c:forEach items="${usuarios}" var="i">																	 								
										  <option value="${i.ID}">${i.nombre}</option>																 
									</c:forEach>
								</select>	
								</div>	
								  <div class="form-group">
									<label for="name">Nombre:</label>
									<input type="text" class="form-control" id="name" required="required" name="name" placeholder="Introduce un nuevo nombre">
								  </div>
								  <div class="form-group">
									<label for="timeBusiness">Horario:</label>
									<input type="text" class="form-control" required="required" id="timeBusiness" name="timeBusiness" placeholder="Introduce un nuevo horario">
								 	<span class="help-block">Por ejemplo: 10-18</span>
								  </div>
								  <div class="form-group">
									<label for="dir">Direcci�n:</label>
									<input type="text" class="form-control" required="required" id="dir" name="dir" placeholder="Introduce una nueva direccion">
								  </div>
								  <div class="form-group">
									<label for="email">Email:</label>
									<input type="email" class="form-control" required="required" id="email" name="email" placeholder="Introduce un nuevo email">
								  </div>
								  <div class="form-group">
									<label for="tel">Tel�fono:</label>
									<input type="tel" class="form-control" required="required" id="tel" name="tel" placeholder="Introduce un nuevo telefono" maxlength="9">
								 	<span class="help-block">Por ejemplo: 651651651</span>
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
						
						<!-- Modal Edit Local-->
						<div class="modal fade" id="ModalEditLocal" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
						      <div class="modal-header">
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        <h4 class="modal-title" id="myModalLabel"> Editar local</h4>
						      </div>
						      <div class="modal-body">
								<form role="form" method="POST" id="formEditarModalLocal" enctype="multipart/form-data">
									<input hidden="submit" id="id_editLocal" name="id_editLocal" />
									<input type="hidden" name="csrf" value="${r:forJavaScript(csrf_token)}"/>
									  <div class="form-group">
										<label for="name">Nombre:</label>
										<input type="text" class="form-control" required="required" id="editNameLocal" name="editNameLocal" placeholder="Introduce un nuevo nombre">
									  </div>
									  <div class="form-group">
										<label for="timeBusiness">Horario:</label>
										<input type="text" class="form-control" required="required" id="editHorarioLocal" name="editHorarioLocal" placeholder="Introduce un nuevo horario">
									 	<span class="help-block">Por ejemplo: 10-18</span>
									  </div>
									  <div class="form-group">
										<label for="dir">Direcci�n:</label>
										<input type="text" class="form-control" required="required" id="editDirLocal" name="editDirLocal" placeholder="Introduce una nueva direccion">
									  </div>
									  <div class="form-group">
										<label for="email">Email:</label>
										<input type="email" class="form-control" required="required" id="editEmailLocal" name="editEmailLocal" placeholder="Introduce un nuevo email">
									  </div>
									  <div class="form-group">
										<label for="tel">Tel�fono:</label>
										<input type="tel" class="form-control" required="required" id="editTelLocal" name="editTelLocal" placeholder="Introduce un nuevo telefono">
									  	<span class="help-block">Por ejemplo: 651651651</span>
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
						<!-- End Modal Edit Local-->	
        			<!-- tags -->
     				<div class="tab-pane fade" id="ltags">
						<div id="TodosTags" class="TodosTags">	
							<c:forEach items="${alltags}" var="i">
								<h4>${i.texto}</h4> 					               				
					         	<button id="editTags_${i.texto}/${i.ID}" value="${i.texto}" class="rellenaEditTag" data-toggle="modal" data-target="#ModalEditTags" >
					         	<span class="glyphicon glyphicon-pencil"></span> Editar</button>	
					         	<HR width=50% align="left">				               				
				            </c:forEach>	
						</div>
					</div>
        			<!--  end tags -->		 
					  <div class="tab-pane fade" id="editarDatos">
									<form role="form" method="POST" id="formuEditUsuario" enctype="multipart/form-data">
										<input type="hidden" name="csrf" value="${r:forJavaScript(csrf_token)}"/>
										<input hidden="submit" name="editId_usuario" id="editId_usuario" value="${admin.ID}" />
										<div class="form-group">
											<label for="name">Nombre:</label>
											<input type="text" class="form-control" name="editNameUser" id="editNameUser" value="${admin.nombre}">
										</div>
										<div class="form-group">
											<label for="pwd">Contrase�a:</label>
											<input type="password" class="form-control" name="editPwd" id="editPwd"  value="">
										</div>									
										<div class="form-group">
											<label for="email">Email:</label>
											<input type="email" class="form-control" name="editEmail" id="editEmail" value="${admin.email }">
										</div>
										<div class="form-group">
											<label for="tel">Tel�fono:</label>
											<input type="tel" class="form-control" name="editTel" id="editTel" value="${admin.telefono }">
											<span class="help-block">Por ejemplo: 651651651</span>
										</div>
										<div class="form-group">
											<label for="file">Imagen de perfil:</label>
											<input type="file" name="editFileToUpload" accept="image/*" id="editFileToUpload">											
										</div>																				  
										<br>
										 <button id="editarUsuario" name="editarUsuario" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> Editar</button>
										</form> 
					  </div>				
					  <!-- Modal Edit Tags-->
						<div class="modal fade" id="ModalEditTags" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel">
						  <div class="modal-dialog modal-sm" role="document">
						    <div class="modal-content">
										    
						    		<div class="modal-header">
						    		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						        	<h4 class="modal-title" id="editModalLabel"> Editar tag</h4>

									</div>
									<div class="modal-body">									
										<form role="form" method="POST" enctype="multipart/form-data" action="editarTag">										
										<input type="hidden" name="csrf" value="${r:forJavaScript(csrf_token)}"/>
										<div class="form-group">
											<label for="name">Tag:</label>											
											<input type="text" class="form-control" required="required" value="" id="nameEditTag" name="nameEditTag">
										 	<input hidden="submit" id="id_tag" name="id_tag" value="" />
										  </div>
											<div class="modal-footer">
												<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-send"></span>Aceptar</button>
												<button type="submit" class="btn" data-dismiss="modal">Cancel</button>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
					<!-- End Modal Edit Tags-->
					</div>

				</div>

                    </div><!--/.col-md-4-->

                   
                </div><!--/.services-->
            </div><!--/.row--> 


           
        </div><!--/.container-->
    </section><!--/#feature-->
    <%@ include file="../fragments/footer.jspf" %>
