package bluedot.spectrum.commons.index.operate;

/**
 * 封装查询结构的对象
 * 
 * @author Harold
 * @date 2018年3月21日
 */
public class SearchResult {
	/** 代表结果所在的行号名称*/
	private String cloumnName;
	
	/** 结果内容 */
	private String resultString;
	
	/** 表名 **/
	private String tableName;
	
	/** 主键 **/
	private Integer id;

	public String getCloumnName() {
		return cloumnName;
	}

	public void setCloumnName(String cloumnName) {
		this.cloumnName = cloumnName;
	}

	public String getResultString() {
		return resultString;
	}

	public void setResultString(String resultString) {
		this.resultString = resultString;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Override
	public String toString() {
		return "SearchResult [cloumnName=" + cloumnName + ", resultString=" + resultString + ", tableName=" + tableName
				+ ", id=" + id + "]";
	}

	
}
