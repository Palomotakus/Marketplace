<%-- 
    Document   : empleados
    Created on : 9 oct. 2025, 02:33:44
    Author     : luisc
--%>

<%@page import="java.util.Collections"%>
<%@page import="java.util.Map"%>
<%@page import="com.mycompany.frontend.entidades.Empleado"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Gestión de Empleados - El Buen Lector</title>

        <link rel="stylesheet" href="styles/empleados.css?v=<%= System.currentTimeMillis()%>">

    </head>
    <body>
        <%
            // Lógica de sesión y seguridad
            String rol = (String) session.getAttribute("rol");
            
            // Inicialización segura del mapa de estadísticas
            Map<String, Integer> estadisticas = (Map<String, Integer>) request.getAttribute("estadisticas");
            if (estadisticas == null) {
                estadisticas = Collections.emptyMap(); 
            }
        %>
        
        <div class="sidebar">
            <h2>El Buen Lector</h2>
            <p>Gestión Moderna</p>

            <a href="Inventario" class="nav-item ">📚 Inventario</a>
            <a href="Venta" class="nav-item">💲 Ventas</a>

            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
            <a href="Empleado" class="nav-item active">👥 Empleados</a>
            <a href="Reportes" class="nav-item">📊 Reportes</a>
            <% } %>

            <a href="historial.jsp" class="nav-item">🕓 Historial</a>
            <a href="Catalogo.jsp" class="nav-item"> DEMO CATALOGO</a>


            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

        <div class="main">
            <h1>Gestión de Empleados</h1>
            <p>Administra los usuarios que pueden acceder al sistema</p>

            <div class="cards">
                <div class="card">
                    <div class="info">
                        <h3>Total Empleados</h3>
                        <p><%= estadisticas.getOrDefault("total", 0) %></p>
                    </div>
                    <div class="icon">👥</div>
                </div>
                <div class="card">
                    <div class="info">
                        <h3>Administradores</h3>
                        <p><%= estadisticas.getOrDefault("administradores", 0) %></p>
                    </div>
                    <div class="icon">🛡️</div>
                </div>
                <div class="card">
                    <div class="info">
                        <h3>Vendedores</h3>
                        <p><%= estadisticas.getOrDefault("vendedores", 0) %></p>
                    </div>
                    <div class="icon">👤</div>
                </div>
            </div>

            <div class="list-section">
                <div class="list-header">
                    <div>
                        <h2>Lista de Empleados</h2>
                        <p>Gestiona los accesos al sistema</p>
                    </div>
                    <button class="btn-add">+ Agregar Empleado</button>
                    <div id="modalAgregarEmpleado" class="modal">
                        <div class="modal-content">
                            <span class="close">&times;</span>
                            <h2>Agregar Empleado</h2>

                            <form action="Empleado" method="post">
                                <input type="hidden" name="accion" value="agregar" />

                                <label>DNI</label>
                                <input type="text" name="dni" required />

                                <label>Nombre Completo</label>
                                <input type="text" name="nombre" required />

                                <label>Usuario</label>
                                <input type="text" name="usuario" required />

                                <label>Contraseña</label>
                                <input type="password" name="contrasena" required />

                                <label>Rol</label>
                                <select name="rol" required>
                                    <option value="">Seleccionar rol</option>
                                    <option value="Administrador">Administrador</option>
                                    <option value="Vendedor">Vendedor</option>
                                </select>

                                <div class="modal-actions">
                                    <button type="button" class="cancelar">Cancelar</button>
                                    <button type="submit" class="guardar">Guardar Empleado</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="search-filter">
                    <input type="text" id="buscar" placeholder="Buscar empleados por nombre, usuario o DNI..." />
                    <select>
                        <option>Todos los roles</option>
                        <option>Administrador</option>
                        <option>Vendedor</option>
                    </select>
                </div>

                <table id="tablaEmpleados">
                    <thead>
                        <tr>
                            <th>DNI</th>
                            <th>NOMBRE</th>
                            <th>USUARIO</th>
                            <th>ROL</th>
                            <th>FECHA REGISTRO</th>
                            <th>ESTADO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody>

                        <%
                            List<Empleado> lista = (List<Empleado>) request.getAttribute("listadoEmpleados");
                            if (lista != null) {
                                for (Empleado e : lista) {
                        %>

                        <tr>
                            <td><%= e.getDni()%></td>
                            <td><strong><%= e.getNombre()%></strong></td>
                            <td><%= e.getUsuario()%></td>
                            <td>
                                <%
                                    String claseRol = "vendedor";
                                    if (e.getRol() != null && e.getRol().equals("Administrador")) {
                                        claseRol = "admin";
                                    }
                                %>
                                <span class="rol <%= claseRol%>"><%= e.getRol()%></span>
                            </td>
                            <td><%= e.getFechaRegistro()%></td>
                            <td><span class="estado <%= "Activo".equals(e.getEstado()) ? "activo" : "inactivo"%>"><%= e.getEstado()%></span></td>
                            <td class="acciones">
                                <a href="#" class="edit" data-id="<%= e.getId()%>">Editar</a>

                                <% if ("Activo".equalsIgnoreCase(e.getEstado())) {%>
                                <a href="Empleado?accion=actualizarEstado&id=<%= e.getId()%>&estado=Inactivo" class="deact">Desactivar</a>
                                <% } else {%>
                                <a href="Empleado?accion=actualizarEstado&id=<%= e.getId()%>&estado=Activo" class="activate">Activar</a>
                                <% }%>
                                <a href="Empleado?accion=eliminar&id=<%= e.getId()%>" class="delete" onclick="return confirm('¿Seguro que deseas eliminar este empleado?');" class="delete">Eliminar</a>
                            </td>
                        </tr>

                        <%
                                } // fin del for
                            } // fin del if
                        %>
                    </tbody>
                </table>
                <div id="modalEditarEmpleado" class="modal">
                    <div class="modal-content " style="max-height: fit-content;">
                        <span class="close">&times;</span>
                        <h2>Editar Empleado</h2>

                        <form action="Empleado" method="post">
                            <input type="hidden" name="accion" value="editar" />
                            <input type="hidden" id="editId" name="id" />

                            <label>DNI</label>
                            <input type="text" id="editDni" name="dni" required />

                            <label>Nombre Completo</label>
                            <input type="text" id="editNombre" name="nombre" required />

                            <label>Usuario</label>
                            <input type="text" id="editUsuario" name="usuario" required />

                            <label>Contraseña</label>
                            <input type="password" id="editContrasena" name="contrasena" required />

                            <label>Rol</label>
                            <select id="editRol" name="rol" required>
                                <option value="">Seleccionar rol</option>
                                <option value="Administrador">Administrador</option>
                                <option value="Vendedor">Vendedor</option>
                            </select>
                            <div class="modal-actions">
                                <button type="button" class="cancelar">Cancelar</button>
                                <button type="submit" class="guardar">Actualizar Empleado</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script>
    const input = document.getElementById('buscar');
    const selectRol = document.querySelector('.search-filter select');
    const filas = document.querySelectorAll('#tablaEmpleados tbody tr');

    function filtrarTabla() {
        const texto = input.value.toLowerCase();
        const rolSeleccionado = selectRol.value.toLowerCase();

        filas.forEach(fila => {
            const columnas = fila.querySelectorAll('td');
            const dni = columnas[0]?.textContent.toLowerCase() || "";
            const nombre = columnas[1]?.textContent.toLowerCase() || "";
            const usuario = columnas[2]?.textContent.toLowerCase() || "";
            const rol = columnas[3]?.textContent.toLowerCase() || "";

            // Condición de búsqueda: texto y rol
            const coincideTexto = dni.includes(texto) || nombre.includes(texto) || usuario.includes(texto);
            const coincideRol = rolSeleccionado === "todos los roles" || rol.includes(rolSeleccionado);

            fila.style.display = (coincideTexto && coincideRol) ? '' : 'none';
        });
    }

    // Escuchamos ambos eventos: escribir y cambiar de rol
    input.addEventListener('keyup', filtrarTabla);
    selectRol.addEventListener('change', filtrarTabla);
</script>
<script>
    // --- Modal Agregar ---
    const modalAgregar = document.getElementById('modalAgregarEmpleado');
    const btnAbrirAgregar = document.querySelector('.btn-add');
    const btnCerrarAgregar = modalAgregar.querySelector('.close');
    const btnCancelarAgregar = modalAgregar.querySelector('.cancelar');

    btnAbrirAgregar.onclick = () => modalAgregar.style.display = 'block';
    btnCerrarAgregar.onclick = () => modalAgregar.style.display = 'none';
    btnCancelarAgregar.onclick = () => modalAgregar.style.display = 'none';

    // --- Modal Editar ---
    const modalEditar = document.getElementById('modalEditarEmpleado');
    const btnCerrarEditar = modalEditar.querySelector('.close');
    const btnCancelarEditar = modalEditar.querySelector('.cancelar');

    // ✅ NUEVO: abrir modal con datos desde backend
    document.querySelectorAll('.edit').forEach(boton => {
        boton.addEventListener('click', async e => {
            e.preventDefault();
            const id = boton.dataset.id;

            try {
                const res = await fetch(`Empleado?accion=obtenerEmpleadoJson&id=\${id}`);
                const data = await res.json();

                // Llenar campos del modal
                document.getElementById('editId').value = data.id;
                document.getElementById('editDni').value = data.dni;
                document.getElementById('editNombre').value = data.nombre;
                document.getElementById('editUsuario').value = data.usuario;
                document.getElementById('editContrasena').value = data.contrasena;
                document.getElementById('editRol').value = data.rol;

                modalEditar.style.display = 'block';
            } catch (error) {
                console.error('Error al obtener datos del empleado:', error);
                alert('No se pudieron cargar los datos del empleado.');
            }
        });
    });

    btnCerrarEditar.onclick = () => modalEditar.style.display = 'none';
    btnCancelarEditar.onclick = () => modalEditar.style.display = 'none';

    // Cierra modales al hacer clic fuera
    window.addEventListener('click', e => {
        if (e.target === modalAgregar)
            modalAgregar.style.display = 'none';
        if (e.target === modalEditar)
            modalEditar.style.display = 'none';
    });
</script>
