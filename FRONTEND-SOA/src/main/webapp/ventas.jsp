<%@page import="com.mycompany.frontend.entidades.Libro"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@page import="com.mycompany.frontend.servicio.CurrencyServicio"%>
<%
    double tipoCambioVenta = CurrencyServicio.obtenerTipoCambioVenta();
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Centro de Ventas - El Buen Lector</title>
        <link rel="stylesheet" href="styles/ventas.css?v=<%= System.currentTimeMillis()%>">
        <style>
            .cliente-info {
                margin-top: 10px;
                background-color: #f9fafb;
                border: 1px solid #ddd;
                border-radius: 6px;
                padding: 10px;
            }
            .cliente-ok {
                background-color: #e0f7e9;
                border-color: #4caf50;
            }
            .cliente-error {
                background-color: #fff3f3;
                border-color: #f44336;
            }
            .error {
                color: red;
                font-size: 0.9em;
                margin-top: 5px;
            }
            input[readonly] {
                background-color: #f3f4f6;
            }
        </style>
    </head>

    <body>

        <%
            String rol = (String) session.getAttribute("rol");
        %>

        <div class="sidebar">
            <h2>El Buen Lector</h2>
            <p>Gestión Moderna</p>
            <!-- 📚 Enlaces visibles para todos -->
            <a href="Inventario" class="nav-item">📚 Inventario</a>
            <a href="Venta" class="nav-item active">💲 Ventas</a>

            <!-- 👥 Solo para Administrador -->
            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
            <a href="Empleado" class="nav-item">👥 Empleados</a>
            <a href="Reportes" class="nav-item">📊 Reportes</a>
            <% }%>

            <!-- 🕓 Visible para todos -->
            <a href="historial.jsp" class="nav-item">🕓 Historial</a>
            <a href="Catalogo.jsp" class="nav-item"> DEMO CATALOGO</a>
            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

        <div class="main">
            <h1>Centro de Ventas</h1>
            <p>Procesa tus ventas de manera rápida y eficiente</p>

            <div class="ventas-container">
                <!-- Columna izquierda -->
                <div class="card">
                    <h2>💲 Nueva Venta</h2>

                    <!-- ====================== DATOS DEL CLIENTE ====================== -->
                    <div class="section blue">
                        <h3>👤 Datos del Cliente</h3>

                        <!-- Formulario para buscar cliente -->
                        <form action="Venta" method="get" style="margin-bottom: 1em;">
                            <input type="text" name="dni" placeholder="DNI del cliente (8 dígitos)" maxlength="8"
                                   value="<%= request.getAttribute("dni") != null ? request.getAttribute("dni") : ""%>" required />
                            <input type="hidden" name="accion" value="buscarDni">
                            <button type="submit" class="btn btn-blue">Buscar Cliente</button>
                        </form>

                        <%
                            Boolean hayDni = (Boolean) request.getAttribute("hayDni");
                            String nombreCompleto = (String) request.getAttribute("nombreCompleto");
                            String apellidoPaterno = (String) request.getAttribute("apellidoPaterno");
                            String apellidoMaterno = (String) request.getAttribute("apellidoMaterno");
                            String dni = (String) request.getAttribute("dni");
                            String error = (String) request.getAttribute("error");
                        %>

                        <% if (hayDni != null) {%> 
                        <div class="cliente-info <%= hayDni ? "cliente-ok" : "cliente-error"%>">
                            <% if (hayDni) { %>
                            <p>✅ Cliente encontrado, los datos se cargaron automáticamente.</p>
                            <% } else { %>
                            <p>❗ No se encontró el cliente, ingrésalo manualmente:</p>
                            <% if (error != null) {%><p class="error"><%= error%></p><% } %>
                            <% }%>

                            <form action="VentaServlet" method="post" style="display:flex; flex-direction:column; gap:8px;">
                                <input type="hidden" name="dni" value="<%= dni != null ? dni : ""%>">

                                <input type="text" name="nombre" placeholder="Nombre completo" 
                                       value="<%= hayDni && nombreCompleto != null ? nombreCompleto : ""%>"
                                       <%= hayDni ? "readonly" : ""%> />

                                <input type="text" name="apellido1" placeholder="Primer apellido" 
                                       value="<%= hayDni && apellidoPaterno != null ? apellidoPaterno : ""%>"
                                       <%= hayDni ? "readonly" : ""%> />

                                <input type="text" name="apellido2" placeholder="Segundo apellido" 
                                       value="<%= hayDni && apellidoMaterno != null ? apellidoMaterno : ""%>"
                                       <%= hayDni ? "readonly" : ""%> />
                            </form>
                        </div>
                        <% } %>
                    </div>

                    <!-- ====================== BUSCAR LIBROS ====================== -->
                    <div class="section orange">
                        <h3>📘 Buscar Libros</h3>
                        <input type="text" id="buscarLibro" placeholder="Buscar por título, autor o código..." />

                        <select id="listaLibros">
                            <option value="">Seleccionar libro...</option>
                            <%
                                List<Libro> lista = (List<Libro>) request.getAttribute("listaLibros");
                                if (lista != null) {
                                    for (Libro l : lista) {
                            %>
                            <option 
                                value="<%= l.getId()%>"
                                data-titulo="<%= l.getTitulo()%>"
                                data-autor="<%= l.getAutor()%>"
                                data-precio="<%= l.getPrecio()%>"
                                data-stock="<%= l.getStock()%>">
                                <%= l.getTitulo() + " - " + l.getAutor()
                                        + " - S/ " + String.format("%.2f", l.getPrecio())
                                        + " ($" + String.format("%.2f", l.getPrecio() / tipoCambioVenta) + ")"
                                        + " (Stock: " + l.getStock() + ")"%>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <input type="number" placeholder="Cantidad" min="1" />
                        <button class="btn btn-green">Agregar</button>
                    </div>

                    <!-- ====================== FORMULARIO FINALIZAR VENTA ====================== -->
                    <form action="Venta" method="post" id="formFinalizar">
                        <!-- Datos ocultos del cliente -->
                        <div class="section blue" style="display: none;">
                            <input type="text" name="dni" maxlength="8"
                                   value="<%= request.getAttribute("dni") != null ? request.getAttribute("dni") : ""%>">
                            <input type="text" name="nombre"
                                   value="<%= request.getAttribute("nombreCompleto") != null ? request.getAttribute("nombreCompleto") : ""%>">
                            <input type="text" name="apellido1"
                                   value="<%= request.getAttribute("apellidoPaterno") != null ? request.getAttribute("apellidoPaterno") : ""%>">
                            <input type="text" name="apellido2"
                                   value="<%= request.getAttribute("apellidoMaterno") != null ? request.getAttribute("apellidoMaterno") : ""%>">
                        </div>

                        <!-- Libros -->
                        <div class="section green">
                            <h3>📚 Libros en Venta</h3>
                            <div id="listaCarrito">
                                <p style="color:#9ca3af;">Aún no hay libros agregados</p>
                            </div>
                        </div>

                        <!-- Total -->
                        <div class="total">
                            <p>Total a Pagar:</p>
                            <span id="totalPagar">S/ 0.00</span>
                        </div>

                        <input type="hidden" id="jsonCarrito" name="jsonCarrito">
                        <button type="submit" class="finalizar">Finalizar Venta</button>
                    </form>

                </div>

                <%
                    Boolean reciboGenerado = (Boolean) request.getAttribute("reciboGenerado");
                    String clienteNombre = (String) request.getAttribute("clienteNombre");
                    String clienteDni = (String) request.getAttribute("clienteDni");
                    String fechaVenta = (String) request.getAttribute("fechaVenta");
                    String numeroRecibo = (String) request.getAttribute("numeroRecibo");
                    Double totalVenta = (Double) request.getAttribute("totalVenta");
                    List<Libro> librosVendidos = (List<Libro>) request.getAttribute("librosVendidos");
                %>

                <div class="card">
                    <h2>📄 Recibo de Venta</h2>

                    <% if (reciboGenerado != null && reciboGenerado) {%>
                    <div class="recibo-card" id="recibo">
                        <div class="recibo-header">
                            <div class="icono">📘</div>
                            <h2>RECIBO DE VENTA</h2>
                            <h3>El Buen Lector</h3>
                            <small>N° <%= numeroRecibo != null ? numeroRecibo : "000000"%></small><br>
                            <small><%= fechaVenta != null ? fechaVenta : ""%></small>
                        </div>

                        <div class="section-recibo">
                            <h4>👤 Datos del Cliente:</h4>
                            <p><strong>📛 Nombre:</strong> <%= clienteNombre != null ? clienteNombre : "N/A"%></p>
                            <p><strong>🆔 DNI:</strong> <%= clienteDni != null ? clienteDni : "N/A"%></p>
                        </div>

                        <div class="section-recibo">
                            <h4>📚 Libros Comprados:</h4>
                            <% if (librosVendidos != null && !librosVendidos.isEmpty()) {
                                    for (Libro l : librosVendidos) {%>
                            <div class="libro-item">
                                <span>
                                    <%= l.getTitulo()%><br>
                                    <small><%= l.getAutor()%></small>
                                </span>
                                <span>S/ <%= String.format("%.2f", l.getPrecio())%></span>
                            </div>
                            <% }
                            } else { %>
                            <p style="color:#9ca3af;">No se registraron libros.</p>
                            <% }%>
                        </div>

                        <div class="total-section">
                            <strong>💰 TOTAL A PAGAR:</strong>
                            <span>S/ <%= totalVenta != null ? String.format("%.2f", totalVenta) : "0.00"%></span>
                        </div>

                        <button class="btn-imprimir">🖨️ Imprimir Recibo</button>
                        <p class="mensaje-final">📗 Gracias por su compra en <strong>El Buen Lector</strong><br>¡Esperamos verle pronto!</p>
                    </div>

                    <% } else { %>
                    <div class="recibo">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                              d="M9 12h6m-6 4h6m2 4H7a2 2 0 01-2-2V6a2 2 0 012-2h5l2 2h5a2 2 0 012 2v12a2 2 0 01-2 2z" />
                        </svg>
                        <h4>Recibo Pendiente</h4>
                        <p>El recibo aparecerá aquí después de finalizar la venta</p>
                    </div>
                    <% } %>
                </div>

            </div>
        </div>

        <input type="hidden" id="jsonCarrito" name="jsonCarrito">
    </body>
</html>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const btnAgregar = document.querySelector(".btn.btn-green");
        const listaCarrito = document.getElementById("listaCarrito");
        const totalPagar = document.getElementById("totalPagar");
        const inputJson = document.getElementById("jsonCarrito");
        const forms = document.querySelectorAll("form");
        const formCliente = document.querySelector('.cliente-info form');
        const formFinalizar = document.getElementById('formFinalizar');

        window.carrito = [];
    <% String carritoJson = (String) request.getAttribute("carritoLibros");
        if (carritoJson != null && !carritoJson.isEmpty()) {%>
        try {
            carrito = JSON.parse('<%= carritoJson.replace("\\", "\\\\").replace("'", "\\'")%>');
        } catch (e) {
            console.error("Error al parsear carrito desde servidor:", e);
            carrito = [];
        }
    <% }%>

        renderCarrito();

        if (btnAgregar) {
            btnAgregar.addEventListener("click", (e) => {
                e.preventDefault();
                const select = document.getElementById("listaLibros");
                const cantidadInput = document.querySelector("input[type='number']");
                const opcion = select.options[select.selectedIndex];
                const cantidad = parseInt(cantidadInput.value);

                if (!opcion.value || isNaN(cantidad) || cantidad <= 0) {
                    alert("Seleccione un libro y una cantidad válida");
                    return;
                }

                const codigo = opcion.value;
                const titulo = opcion.dataset.titulo;
                const autor = opcion.dataset.autor;
                const precio = parseFloat(opcion.dataset.precio);
                const stock = parseInt(opcion.dataset.stock);

                if (cantidad > stock) {
                    alert(`❗ Solo hay \${stock} unidades disponibles de "\${titulo}"`);
                    return;
                }

                const existente = carrito.find((l) => l.codigo === codigo);
                if (existente) {
                    if (existente.cantidad + cantidad > stock) {
                        alert(`❗ No puedes agregar más de \${stock} unidades de "\${titulo}"`);
                        return;
                    }
                    existente.cantidad += cantidad;
                    existente.subtotal = existente.cantidad * existente.precio;
                } else {
                    carrito.push({codigo, titulo, autor, precio, cantidad, stock, subtotal: precio * cantidad});
                }

                renderCarrito();
            });
        }

        function renderCarrito() {
            listaCarrito.innerHTML = "";
            if (carrito.length === 0) {
                listaCarrito.innerHTML = `<p style="color:#9ca3af;">Aún no hay libros agregados</p>`;
                totalPagar.textContent = "S/ 0.00";
                inputJson.value = "";
                return;
            }
            carrito.forEach((libro, i) => {
                const item = document.createElement("div");
                item.classList.add("item-carrito");
                item.innerHTML = `
                <div class="info-libro">
                    <strong>\${libro.titulo}</strong><br>
                    <small>\${libro.autor}</small><br>
                    <span class="precio">S/ \${libro.precio.toFixed(2)} × \${libro.cantidad}</span>
                </div>
                <div class="subtotal">
                    <span class="monto">S/ \${libro.subtotal.toFixed(2)}</span>
                    <span class="eliminar" data-index="\${i}">🗑️</span>
                </div>
            `;
                listaCarrito.appendChild(item);
            });
            const total = carrito.reduce((acc, l) => acc + l.subtotal, 0);
            totalPagar.textContent = `S/ \${total.toFixed(2)}`;
            inputJson.value = JSON.stringify(carrito);
        }

        listaCarrito.addEventListener("click", (e) => {
            if (e.target.classList.contains("eliminar")) {
                const index = e.target.dataset.index;
                carrito.splice(index, 1);
                renderCarrito();
            }
        });

        // ✅ Copiar datos del cliente antes de enviar la venta
        if (formCliente && formFinalizar) {
            formFinalizar.addEventListener('submit', (e) => {
                const campos = ['dni', 'nombre', 'apellido1', 'apellido2'];
                campos.forEach(campo => {
                    const inputCliente = formCliente.querySelector(`[name="\${campo}"]`);
                    let inputFinal = formFinalizar.querySelector(`[name="\${campo}"]`);
                    if (inputCliente) {
                        if (!inputFinal) {
                            inputFinal = document.createElement('input');
                            inputFinal.type = 'hidden';
                            inputFinal.name = campo;
                            formFinalizar.appendChild(inputFinal);
                        }
                        inputFinal.value = inputCliente.value;
                    }
                });
            });
        }

        // 🧠 Manejo dinámico del required (evita error "not focusable")
        const hiddenInputs = formFinalizar.querySelectorAll('input[name]');
        hiddenInputs.forEach(i => i.removeAttribute('required'));

        // Reactivar required solo al enviar
        formFinalizar.addEventListener('submit', () => {
            hiddenInputs.forEach(i => i.setAttribute('required', 'true'));
        });

        // Guardar carrito en todos los formularios
        forms.forEach(form => {
            form.addEventListener("submit", () => {
                const json = JSON.stringify(carrito || []);
                inputJson.value = json;
                if (!form.contains(inputJson)) {
                    const clone = inputJson.cloneNode();
                    clone.value = json;
                    form.appendChild(clone);
                }
            });
        });
    });
</script>
