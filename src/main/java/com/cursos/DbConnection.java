package com.cursos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    private static final String URL = requireEnvironmentVariable("DB_URL");
    private static final String USER = requireEnvironmentVariable("DB_USER");
    private static final String PASSWORD = requireEnvironmentVariable("DB_PASSWORD");

    static {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("No se pudo cargar el driver JDBC de Oracle", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static String requireEnvironmentVariable(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException(
                    "La variable de entorno " + name + " no está configurada");
        }
        return value;
    }
}
