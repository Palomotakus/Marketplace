package com.mycompany.frontend.entidades;

import java.time.LocalDateTime;
import java.util.ArrayList;

public class Venta {

    private int id;
    private String dni;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private LocalDateTime fecha;
    private double total;
    private String estado;

    // 🔹 Constructores
    public Venta() {
        detalles = new ArrayList<>();
    }

    public Venta(int id, String dni, String nombre, String apellidoPaterno, String apellidoMaterno, LocalDateTime fecha, double total, String estado) {
        this.id = id;
        this.dni = dni;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.fecha = fecha;
        this.total = total;
        this.estado = estado;
    }

    // 🔹 Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
// Relación con los detalles de venta
    private java.util.List<DetalleVenta> detalles;

    public java.util.List<DetalleVenta> getDetalles() {
        return detalles;
    }

    public void setDetalles(java.util.List<DetalleVenta> detalles) {
        this.detalles = detalles;
    }
}
