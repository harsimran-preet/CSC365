import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.util.Map;
import java.util.Scanner;
import java.util.LinkedHashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;

public class InnReservations {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int menuOpt = 0;
        
        while (menuOpt != 7) {
            menuOpt = menu(input);
            try {
                if (menuOpt <= 0 || menuOpt > 7) {
                    System.out.println("Invalid option. Try again");
                    continue;
                }
                switch(menuOpt) {
                    case 1: //fr1
                    System.out.println("Rooms and Rates\n");
                    fr1();
                    break;
                    case 2: fr2(input);
                    break;
                    case 3: //fr3
                    break;
                    case 4: //fr4
                    break;
                    case 5: //fr4
                    break;
                    case 6: //fr4
                    break;
                }
            } catch (SQLException e) {
                System.err.println("SQLException: " + e.getMessage());
            } catch (Exception e2) {
                System.err.println("Exception: " + e2.getMessage());
            }
        }
        
        input.close();
    }
    
    private static int menu(Scanner sc) {
        int opt = 0;

        System.out.println();
        System.out.println("1. Rooms and Rates");
        System.out.println("2. Reservations");
        System.out.println("3. Reservation Change");
        System.out.println("4. Reservation Cancellation");
        System.out.println("5. Detailed Reservation Information");
        System.out.println("6. Revenue");
        System.out.println("7. Exit");
        System.out.println();
        System.out.print("Choose one of the following options (1-7): ");
        opt = sc.nextInt();

        return opt;
    }
    //FR1
    private static void fr1() throws SQLException{
        try{

            String sqlstate1 = "with R1a as(select code, room, rate, checkin, checkout, Least(Datediff(checkout, checkin), datediff(checkout, date_sub(curdate(), interval 180 day)), datediff(curdate(), checkin), datediff(curdate(), date_sub(curdate(), interval 180 day))) as intersect from jpark187.lab7_reservations rs where checkin <= curdate() and checkout >= Date_sub(curdate(), interval 180 day)), "+
                                "R1b as(select room, Round(sum(intersect)/180, 2) as popularity from R1a group by room), "+
                                "R1c as (select room, Greatest(curdate(), max(checkout)) as nextcheckinavailability from jpark187.lab7_reservations rs group by room), "+
                                "R1d as(select room, max(checkout) as latestcheckout, datediff(Max(checkout), max(checkin)) as lateststay from jpark187.lab7_reservations rs group by room) "+
                                "select roomCode, roomname, beds, bedtype, maxocc, baseprice, decor, IFNULL(popularity, 0) as popularity, nextcheckinavailability, lateststay, latestcheckout from jpark187.lab7_rooms "+
                                "left outer join R1b on R1b.room = jpark187.lab7_rooms.RoomCode  "+
                                "left outer join R1c on jpark187.lab7_rooms.RoomCode = R1c.room "+
                                "left outer join R1d on R1d.room = jpark187.lab7_rooms.RoomCode "+
                                "order by popularity desc;";
            try (Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"),
                                System.getenv("JDBC_USER"),
                                System.getenv("JDBC_PW"))) {
                                    try(Statement statem = conn.createStatement(); ResultSet res = statem.executeQuery(sqlstate1)){
                                        while(res.next()){
                                            String roomCode = res.getString("roomCode");
                                            String roomname = res.getString("roomname");
                                            int beds = res.getInt("beds");
                                            String  bedtype = res.getString("bedtype");
                                            int maxocc = res.getInt("maxocc");
                                            int baseprice = res.getInt("baseprice");
                                            String decor = res.getString("decor");
                                            float popularity = res.getFloat("popularity");
                                            Date nextcheckinavailability = res.getDate("nextcheckinavailability");
                                            int lateststay = res.getInt("lateststay");
                                            Date latestcheckout = res.getDate("latestcheckout");
                                            
                                            System.out.printf("%s\t\t%-25s%d\t%s\t%d\t%.2f\t%-15s%.2f\t\t%tF\t%d\t\t%tF\n", roomCode, roomname, beds, 
                                            bedtype,maxocc, baseprice, decor, popularity, nextcheckinavailability, lateststay, latestcheckout);

                                        }

                                        }
                                    }
                                }
            catch(final SQLException e){
                e.printStackTrace();
            }

        }
    //Functional Requirement 2: Reservations
    private static void fr2(Scanner sc) throws SQLException {
        try (Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"),
                                System.getenv("JDBC_USER"),
                                System.getenv("JDBC_PW"))) {

            String firstname,
                   lastname,
                   roomCode = "Any",
                   bedType,
                   checkInDate,
                   checkOutDate,
                   numOfChildren,
                   numOfAdults;
                                    
            System.out.print("Enter first name: ");
            firstname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
            System.out.print("Enter desired room number (Default 'Any'): ");
            lastname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
            System.out.print("Enter last name: ");
            lastname = sc.next();
        }
    }
    public static void fr3(){
        try{
            Scanner scanner = new Scanner(System.in);

            System.out.println("Please enter your reservation code: ");
            int res_code = scanner.nextInt();
            scanner.nextLine();

            Map<String, String> changes = new HashMap<>();
            while(true){
                System.out.println("What attribute would you like to change? ");
                System.out.println("a - First Name ");
                System.out.println("b - Last Name");
                System.out.println("c - Begin Date");
                System.out.println("d - End Date");
                System.out.println("e - Number of Adults");
                System.out.println("f - Number of Children");
                System.out.println("q - Quit");
                String ip = scanner.next();
                scanner.nextLine();
                if (ip.equalsIgnoreCase("q")){
                    break;
                }
                switch(ip){
                    case "a":
                        System.out.println("New first name: ");
                        String first_name = scanner.nextLine();
                        changes.put("FirstName", first_name);
                        break;
                    case "b":
                        System.out.println("New last name: ");
                        String last_name = scanner.nextLine();
                        changes.put("LastName", first_name);
                        break;
                    case "c":
                        System.out.println("New start date: ");
                        String start = scanner.nextLine();
                        changes.put("CheckIn", first_name);
                        break;
                    case "d":
                        System.out.println("New end name: ");
                        String end = scanner.nextLine();
                        changes.put("Checkout", first_name);
                        break;
                    case "e":
                        System.out.println("New number of adults: ");
                        String adults = scanner.nextLine();
                        changes.put("Adults", adults);
                        break;
                    case "f":
                        System.out.println("New number of kids: ");
                        String kids = scanner.nextLine();
                        changes.put("Kids", first_name);
                        break;
                    
                }
            }
            if(changes.containsKey("FirstName")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set firstname = ? where code = ?;")){
                    preparedStatement.setString(1,changes.get("FirstName"));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
                }
            if(changes.containsKey("LastName")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set LastName = ? where code = ?;")){
                    preparedStatement.setString(1,changes.get("LastName"));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
                }
            if(changes.containsKey("Adults")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set Adults = ? where code = ?;")){
                    preparedStatement.setInt(1,Integer.parseInt(changes.get("Adults")));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
                }
            if(changes.containsKey("Kids")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set Kids = ? where code = ?;")){
                    preparedStatement.setInt(1,Integer.parseInt(changes.get("Kids")));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
                }
            if(changes.containsKey("CheckIn")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set CheckIn = ? where code = ?;")){
                    preparedStatement.setDate(1, Date.valueOf(changes.get("CheckIn")));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
                }
            if(changes.containsKey("Checkout")){
                try(Connection conn = DriverManager.getConnection(System.getenv("JDBC_URL"), System.getenv("JDBC_USER"),System.getenv("JDBC_PW"))) {
                    try(PreparedStatement preparedStatement = conn.prepareStatement("UPDATE jpark187.lab7_reservations set Checkout = ? where code = ?;")){
                    preparedStatement.setDate(1, Date.valueOf(changes.get("Checkout")));
                    preparedStatement.setInt(2, res_code);
                    preparedStatement.executeUpdate();
                    
                    conn.commit();
                    System.out.println("Success in updating");
                    
                    }
                catch(SQLException e){
                    System.out.println("\n Error Updateing. Please Try Again!\n");
                    e.printStackTrace();;
                    conn.rollback();
                }
            }
            }
            
        }
            catch(Exception e){
                e.printStackTrace();
            }
        }


}