import com.sun.org.apache.regexp.internal.RE;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class Assignment3 extends JDBCSubmission {

    public Assignment3() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }


    @Override
    public boolean connectDB(String url, String username, String password) {
        //write your code here.
        //calls getConnection() method
        try {
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("connected");
            if (connection != null){
                return true;
            }else {
                return false;
            }


        }catch (SQLException sqle){
            sqle.printStackTrace();
            return false;
        }




    }

    @Override
    public boolean disconnectDB() {
        try{
            connection.close();
            if (connection.isClosed()){
                return true;
            }else{
                return false;
            }

        }catch (SQLException sqle){
            sqle.printStackTrace();
            return false;
        }

    }

    @Override
    public ElectionResult presidentSequence(String countryName) {
        List<Integer> presidents = new ArrayList<Integer>();
        List<String> parties = new ArrayList<String>();
        ElectionResult er = null;
        try{

            String query = "SELECT politician_president.id, party.name " +
                    "FROM politician_president JOIN country " +
                    "on country.id = politician_president.country_id " +
                    "JOIN party " +
                    "on politician_president.party_id = party.id " +
                    "WHERE country.name = \'" + countryName + "\' " +
                    "ORDER BY politician_president.start_date DESC;";

            PreparedStatement pse = connection.prepareStatement(query);
            ResultSet resultSet = pse.executeQuery();
            while (resultSet.next()){
                int pres = resultSet.getInt(1);
                presidents.add(pres);
                String party = resultSet.getString(2);
                parties.add(party);
                resultSet.next();
            }

            resultSet.close();

            er = new ElectionResult(presidents, parties);
        }catch (SQLException sqle){
            sqle.printStackTrace();
        }
        return er;

    }

    @Override
    public List<Integer> findSimilarParties(Integer partyId, Float threshold) {
        List<Integer> simParties = new ArrayList<Integer>();
        try{
            String otherParties = "SELECT id, description FROM party WHERE id <> " + Integer.toString(partyId) + ";";
            String partyDes = "SELECT description FROM PARTY WHERE id = " + Integer.toString(partyId)+ ";";
            PreparedStatement pse0 = connection.prepareStatement(otherParties);
            ResultSet resultSet0 = pse0.executeQuery();
            PreparedStatement pse1 = connection.prepareStatement(partyDes);
            ResultSet resultSet1 = pse1.executeQuery();
            resultSet1.next();
            String partyDescription = resultSet1.getString(1);
            while (resultSet0.next()){
                String a = resultSet0.getString(2);
                double c = similarity(a, partyDescription);
                if(c >= threshold){
                    Integer d = resultSet0.getInt(1);
                    simParties.add(d);
                }
                resultSet0.next();

            }
            resultSet0.close();
            resultSet1.close();

            return simParties;

        }catch (SQLException sqle){
            sqle.printStackTrace();
        }
        return simParties;
    }

    public static void main(String[] args) throws Exception {
        //Write code here.
        System.out.println("Hello World");
    }

}