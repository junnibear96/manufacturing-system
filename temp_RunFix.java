import java.sql.*;

public class RunFix {
    public static void main(String[] args) {
        String url = args[0];
        String user = args[1];
        String pass = args[2];
        
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            System.out.println("Connected to Oracle database");
            
            // Read SQL from stdin
            java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(System.in, "UTF-8"));
            StringBuilder sql = new StringBuilder();
            String line;
            int count = 0;
            
            while ((line = reader.readLine()) != null) {
                if (line.trim().equals("--SPLIT--")) {
                    String statement = sql.toString().trim();
                    if (!statement.isEmpty() && !statement.startsWith("--")) {
                        try {
                            if (statement.toUpperCase().startsWith("SELECT")) {
                                ResultSet rs = stmt.executeQuery(statement);
                                ResultSetMetaData md = rs.getMetaData();
                                int cols = md.getColumnCount();
                                while (rs.next()) {
                                    for (int i=1; i<=cols; i++) {
                                        System.out.print(rs.getString(i) + "\t");
                                    }
                                    System.out.println();
                                }
                                rs.close();
                            } else {
                                int rows = stmt.executeUpdate(statement);
                                System.out.println("Affected rows: " + rows);
                            }
                            count++;
                        } catch (SQLException e) {
                            System.err.println("Error executing statement " + count + ": " + e.getMessage());
                            System.err.println("Statement: " + statement.substring(0, Math.min(100, statement.length())) + "...");
                        }
                    }
                    sql = new StringBuilder();
                } else {
                    sql.append(line).append("\n");
                }
            }
            
            // Execute last statement
            String statement = sql.toString().trim();
            if (!statement.isEmpty() && !statement.startsWith("--")) {
                try {
                     if (statement.toUpperCase().startsWith("SELECT")) {
                        ResultSet rs = stmt.executeQuery(statement);
                        ResultSetMetaData md = rs.getMetaData();
                        int cols = md.getColumnCount();
                        while (rs.next()) {
                            for (int i=1; i<=cols; i++) {
                                System.out.print(rs.getString(i) + "\t");
                            }
                            System.out.println();
                        }
                        rs.close();
                    } else {
                        int rows = stmt.executeUpdate(statement);
                        System.out.println("Affected rows: " + rows);
                    }
                    count++;
                } catch (SQLException e) {
                    System.err.println("Error executing final statement: " + e.getMessage());
                }
            }
            
            System.out.println("Successfully executed " + count + " SQL statements");
            
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
