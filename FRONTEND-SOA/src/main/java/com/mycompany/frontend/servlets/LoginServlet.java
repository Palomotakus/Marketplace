package com.mycompany.frontend.servlets;

import com.mycompany.frontend.entidades.Empleado;
import com.mycompany.frontend.servicio.EmpleadoServicio;
import com.mycompany.frontend.servicio.EmpleadoServicioImpl;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/Login"})
public class LoginServlet extends HttpServlet {

    private final EmpleadoServicio loginServicio = new EmpleadoServicioImpl();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        // valida usuario 
        Empleado empleado = loginServicio.validarUsuario(usuario, password);

        if (empleado != null && empleado.getEstado().equals("Activo")) {

            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuario", empleado.getUsuario());
            sesion.setAttribute("rol", empleado.getRol());

            response.sendRedirect("Inventario");
        } else {

            request.setAttribute("error", "Usuario o contraseña incorrectos");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        

        String accion = request.getParameter("accion");

        if ("cerrar".equalsIgnoreCase(accion)) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.invalidate(); // 🔒 Cierra la sesión actual
            }
            response.sendRedirect("Login");
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
            
        }

    }

    @Override
    public String getServletInfo() {
        return "Servlet de inicio de sesión usando servicio";
    }
}
