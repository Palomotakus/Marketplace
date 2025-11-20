/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.mycompany.frontend.servicio;


import com.mycompany.frontend.entidades.DetalleVenta;
import com.mycompany.frontend.entidades.Venta;
import java.util.List;

/**
 *
 * @author luisc
 */
public interface VentaServicio {
    
    Venta registrarVenta(Venta venta, List<DetalleVenta> detalles);
    
    List<Venta> buscarVentas(String idVenta, String dni, String fecha);
    
    List<Venta> findAll();
}
