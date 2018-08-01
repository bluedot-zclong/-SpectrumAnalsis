package bluedot.spectrum.commons.index.operate;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import bluedot.spectrum.commons.index.connection.MySqlConnection;
import bluedot.spectrum.commons.index.connection.SqlConnection;
import bluedot.spectrum.commons.index.database.Database;
import bluedot.spectrum.commons.index.database.TableAndColumns;
import bluedot.spectrum.commons.index.parser.XmlParser;

public class Test {
	
	public static void main(String[] args) throws Exception{
		//----------------测试mysql的加载-----------------------
//		List<String> cloumns = new ArrayList<String>();
//		
//        cloumns.add("Xm");
//        SqlConnection mySqlConnection = new MySqlConnection();
//        Connection conn = mySqlConnection.getConnection("com.mysql.jdbc.Driver", "jdbc:mysql://localhost:3306/t_spider?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
//                "root", "root");
//       
//        Database datebase = new Database(conn,"t_2017", cloumns, "123");
		
		//----------------测试xml文件的解析-----------------------
		//List<TableAndColumns> tableAndColumnDates = new XmlParser().getTableAndColumDateFromFile("src/main/java/resources/table_and_column.xml");
		
		//测试xml文件在operator中的测试
		IndexMapOperater i = new IndexMapOperater("src/main/java/resources/table_and_column.xml", "src/main/java/resources/data.txt");
		List<SearchResult> list = i.queryIndex("李志");
		for(SearchResult sr :list){
			System.out.println(sr.toString());
		}
//		LinkedList<Integer> a = new LinkedList<>();
//		a.add(1);
//		a.add(1);
//		
//		System.out.println(a.removeFirst());
//		System.out.println(a.removeLast());
//		int l = a.getLast();
//		System.out.println(l);
//		List<Integer> l = new ArrayList<>();
//		l.add(1);
//		l.add(2);
//		List<Integer> a = l;
//		l = new ArrayList<>();
//		System.out.println(a.get(l.size() - 1));
//		String a = "asdawda我会SASDasdASF哈哈哈";
//		System.out.println(a.toLowerCase().toCharArray());
//		char c = '哈';
//		int v = (int)c;
//		System.out.println(v);
		
//		String str="比如1234说这个吧！就是这个了";
//		//str = str.substring(0, 4);
//		
//		System.out.println(str.length());
//		
//		char[] chars = str.toCharArray();
//		
//		for(char c : chars){
//			System.out.println(c);
//		}
//		
//		//System.out.println(tokenziker.toString());
//		System.out.println(str);
		
//		Map a = new HashMap<String, String>();
//		a.put("1", "1");
//		System.out.println(a.get("1"));
//		System.out.println((List)a.get("2"));
	}
		
}
