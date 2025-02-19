package org.library;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FlywayHistory {

    private static final String URL = "jdbc:postgresql://localhost:5432/library_management";
    private static final String USER = "postgres";
    private static final String PASSWORD = "root";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            String sql = "SELECT * FROM flyway_schema_history";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                File file = new File("D:\\Java\\TMS_C32_Lesson_35\\src\\src\\main\\resources\\FlywayHistory.txt");

                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    while (rs.next()) {
                        String version = rs.getString("version");
                        String description = rs.getString("description");
                        String type = rs.getString("type");
                        String script = rs.getString("script");
                        String checksum = rs.getString("checksum");
                        String installedBy = rs.getString("installed_by");
                        String installedOn = rs.getString("installed_on");
                        String executionTime = rs.getString("execution_time");
                        boolean success = rs.getBoolean("success");

                        writer.write("Version: " + version + "\n");
                        writer.write("Description: " + description + "\n");
                        writer.write("Type: " + type + "\n");
                        writer.write("Script: " + script + "\n");
                        writer.write("Checksum: " + checksum + "\n");
                        writer.write("Installed by: " + installedBy + "\n");
                        writer.write("Installed on: " + installedOn + "\n");
                        writer.write("Execution time: " + executionTime + "\n");
                        writer.write("Success: " + success + "\n");
                        writer.write("----------------------------\n");
                    }
                    System.out.println("Data has been written to FlywayHistory.txt.");
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
