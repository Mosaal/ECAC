import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

public class Main {
	// TODO
	// Write calculated data to CSV's

	// Load data
	private static File clients = new File("./data/client.csv");
	private static File districts = new File("./data/district.csv");

	/**
	 * Calculate the total of men and women
	 * @throws IOException
	 */
	public static void clientsPerGender() throws IOException {
		// Separate men from women
		ArrayList<String> men = new ArrayList<>();
		ArrayList<String> women = new ArrayList<>();

		// Set file reader
		String line = null;
		BufferedReader br = new BufferedReader(new FileReader(clients));

		// Ignore first line because it contains column names
		br.readLine();

		// Read it line by line
		while ((line = br.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// Second column refers to birth date (YYMMDD - men; YY(MM + 50)DD - women)
			String date = data[1].replaceAll("\"", "");

			// Check month (>50 - women; <50 - men)
			if ((Integer.parseInt(date) / 100) % 100 < 50) {
				men.add(line);
			} else if ((Integer.parseInt(date) / 100) % 100 > 50) {
				women.add(line);
			}
		}

		// Close reader
		br.close();

		// Print statistics
		System.out.println("GENDER : TOTAL");
		System.out.println("Men : " + men.size());
		System.out.println("Women : " + women.size());
	}

	/**
	 * Calculate the total of clients birthed in each decade
	 * @throws IOException
	 */
	public static void clientsPerDecade() throws IOException {
		// Separate clients by birth decade
		HashMap<String, Integer> cliDec = new HashMap<>();

		// Set decades <20 to >80
		cliDec.put("<20", 0);
		for (int i = 20; i < 80; i += 10) {
			cliDec.put(i + " - " + (i + 10), 0);
		}
		cliDec.put(">80", 0);

		// Set file reader
		String line = null;
		BufferedReader br = new BufferedReader(new FileReader(clients));

		// Ignore first line because it contains column names
		br.readLine();

		// Read it line by line
		while ((line = br.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// Second column refers to birth date (YYMMDD - men; YY(MM + 50)DD - women)
			String date = data[1].replaceAll("\"", "");

			// Check decade <20
			if (Integer.parseInt(date) / 10000 < 20) {
				cliDec.put("<20", cliDec.get("<20").intValue() + 1);
			}

			// Check decades 20 through 80
			for (int i = 20; i < 80; i += 10) {
				if (Integer.parseInt(date) / 10000 >= i && Integer.parseInt(date) / 10000 < i + 10) {
					cliDec.put(i + " - " + (i + 10), cliDec.get(i + " - " + (i + 10)).intValue() + 1);
				}
			}

			// Check decade >80
			if (Integer.parseInt(date) / 10000 >= 80) {
				cliDec.put(">80", cliDec.get(">80").intValue() + 1);
			}
		}

		// Close reader
		br.close();

		// Print statistics
		System.out.println("DECADE : TOTAL");
		for (Entry<String, Integer> decade: cliDec.entrySet()) {
			System.out.println(decade.getKey() + " : " + decade.getValue());
		}
	}

	/**
	 * Calculate the total of clients per region
	 * @throws IOException
	 */
	public static void clientsPerRegion() throws IOException {
		// Count how many clients there are per region
		HashMap<Integer, Integer> cliDis = new HashMap<>(); // DistrictID -> #Clients

		// Set file reader
		String line = null;
		BufferedReader clientsBr = new BufferedReader(new FileReader(clients));

		// Ignore first line because it contains column names
		clientsBr.readLine();

		// Read it line by line
		while ((line = clientsBr.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// Third column refers to district
			String district = data[2];

			// Check if it contains
			if (cliDis.containsKey(Integer.parseInt(district))) {
				cliDis.put(Integer.parseInt(district), cliDis.get(Integer.parseInt(district)).intValue() + 1);
			} else {
				cliDis.put(Integer.parseInt(district), 1);
			}
		}

		// Close clients reader
		clientsBr.close();

		// Get all the districts per region
		HashMap<String, ArrayList<Integer>> regDis = new HashMap<>(); // Region -> Districts

		// Set file reader
		line = null;
		BufferedReader districtsBr = new BufferedReader(new FileReader(districts));

		// Ignore first line because it contains column names
		districtsBr.readLine();

		// Read it line by line
		while ((line = districtsBr.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// First column refers to district
			String district = data[0];

			// Third column refers to region
			String region = data[2];

			// Check if it contains
			if (regDis.containsKey(region.trim())) {
				// Get current list and update it
				ArrayList<Integer> disList = regDis.get(region.trim());
				disList.add(Integer.parseInt(district));

				// Update region
				regDis.put(region.trim(), disList);
			} else {
				// Create list and add first district
				ArrayList<Integer> disList = new ArrayList<>();
				disList.add(Integer.parseInt(district));

				// Set region
				regDis.put(region.trim(), disList);
			}
		}

		// Close districts reader
		districtsBr.close();

		// Get number of clients per region
		HashMap<String, Integer> regCli = new HashMap<>(); // Region -> #Clients

		// Calculate total number of clients per region
		for (Entry<String, ArrayList<Integer>> region: regDis.entrySet()) {
			// Get all districts of corresponding region
			regCli.put(region.getKey(), 0);
			ArrayList<Integer> disList = region.getValue();

			// Check the total of each district
			for (int i = 0; i < disList.size(); i++) {
				int temp = regCli.get(region.getKey()).intValue();
				regCli.put(region.getKey(), temp + cliDis.get(disList.get(i)).intValue());
			}
		}

		// Print statistics
		System.out.println("REGION : TOTAL");
		for (Entry<String, Integer> region: regCli.entrySet()) {
			System.out.println(region.getKey() + " : " + region.getValue().intValue());
		}
	}

	/**
	 * Calculate the total of clients by district population size
	 * @throws IOException
	 */
	public static void clientsAverageSalary() throws IOException {
		// Count how many clients there are per average salary per district
		HashMap<Integer, Integer> cliDis = new HashMap<>(); // DistrictID -> #Clients

		// Set file reader
		String line = null;
		BufferedReader clientsBr = new BufferedReader(new FileReader(clients));

		// Ignore first line because it contains column names
		clientsBr.readLine();

		// Read it line by line
		while ((line = clientsBr.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// Third column refers to district
			String district = data[2];

			// Check if it contains
			if (cliDis.containsKey(Integer.parseInt(district))) {
				cliDis.put(Integer.parseInt(district), cliDis.get(Integer.parseInt(district)).intValue() + 1);
			} else {
				cliDis.put(Integer.parseInt(district), 1);
			}
		}

		// Close clients reader
		clientsBr.close();

		// Get all the districts per region
		HashMap<String, ArrayList<Integer>> regDis = new HashMap<>(); // Region -> Districts

		// Set file reader
		line = null;
		BufferedReader districtsBr = new BufferedReader(new FileReader(districts));

		// Ignore first line because it contains column names
		districtsBr.readLine();

		// Read it line by line
		while ((line = districtsBr.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");

			// First column refers to district
			String district = data[0];

			// Third column refers to region
			String region = data[2];

			// Check if it contains
			if (regDis.containsKey(region.trim())) {
				// Get current list and update it
				ArrayList<Integer> disList = regDis.get(region.trim());
				disList.add(Integer.parseInt(district));

				// Update region
				regDis.put(region.trim(), disList);
			} else {
				// Create list and add first district
				ArrayList<Integer> disList = new ArrayList<>();
				disList.add(Integer.parseInt(district));

				// Set region
				regDis.put(region.trim(), disList);
			}
		}

		// Close districts reader
		districtsBr.close();
		
		// Get number of clients per region
		HashMap<String, Integer> regCli = new HashMap<>(); // Region -> #Clients

		// Calculate total number of clients per region
		for (Entry<String, ArrayList<Integer>> region: regDis.entrySet()) {
			// Get all districts of corresponding region
			regCli.put(region.getKey(), 0);
			ArrayList<Integer> disList = region.getValue();

			// Check the total of each district
			for (int i = 0; i < disList.size(); i++) {
				int temp = regCli.get(region.getKey()).intValue();
				regCli.put(region.getKey(), temp + cliDis.get(disList.get(i)).intValue());
			}
		}

		// Get the average salaries per region
		HashMap<String, ArrayList<Integer>> regSal = new HashMap<>(); // Region -> Average Salaries

		// Set file reader
		line = null;
		districtsBr = new BufferedReader(new FileReader(districts));

		// Ignore first line because it contains column names
		districtsBr.readLine();
		
		// Read it line by line
		while ((line = districtsBr.readLine()) != null) {
			// Separate with ';' delimiter
			String[] data = line.split(";");
			
			// Third column refers to region
			String region = data[2];
			
			// Eleventh column refers to average salary
			String avgSal = data[10];
			
			// Check if it contains
			if (regSal.containsKey(region.trim())) {
				// Get current list and update it
				ArrayList<Integer> avgSals = regSal.get(region.trim());
				avgSals.add(Integer.parseInt(avgSal));

				// Update region
				regSal.put(region.trim(), avgSals);
			} else {
				// Create list and add first salary
				ArrayList<Integer> avgSals = new ArrayList<>();
				avgSals.add(Integer.parseInt(avgSal));

				// Set region
				regSal.put(region.trim(), avgSals);
			}
		}
		
		// Get the average salaries per region
		HashMap<String, Double> regAvgSal = new HashMap<>(); // Region -> Average Salary
		
		// Go through each region
		for (Entry<String, ArrayList<Integer>> region: regSal.entrySet()) {
			// Get average salaries
			ArrayList<Integer> sals = region.getValue();
			
			// Sum all the averages
			double totalAvg = 0;
			for (int i = 0; i < sals.size(); i++) {
				totalAvg += sals.get(i);
			}
			
			// Calculate the average
			String res = String.format("%.2f", totalAvg / sals.size()).split(",")[0];
			res += "." + String.format("%.2f", totalAvg / sals.size()).split(",")[1];
			regAvgSal.put(region.getKey(), Double.parseDouble(res));
		}
		
		// Get number of clients per average salary
		HashMap<Integer, Double> cliAvgSal = new HashMap<>(); // #Clients -> Average Salary
		
		// Calculate total number of clients per average salary
		for (Entry<String, Double> region: regAvgSal.entrySet()) {
			// Get the region's # of clients and its average salary
			cliAvgSal.put(regCli.get(region.getKey()), regAvgSal.get(region.getKey()));
		}
		
		// Print statistics
		System.out.println("CLIENTS : AVG. SALARY");
		for (Entry<Integer, Double> obj: cliAvgSal.entrySet()) {
			System.out.println(obj.getKey().intValue() + " : " + obj.getValue().doubleValue());
		}
	}

	/**
	 * Application's starting point
	 * @param args command line's arguments
	 * @throws IOException
	 */
	public static void main(String[] args) throws IOException {
//		clientsPerGender();
//		System.out.println();

//		clientsPerDecade();
//		System.out.println();

//		clientsPerRegion();
//		System.out.println();

//		clientsAverageSalary();
//		System.out.println();
	}
}
