package bluedot.spectrum.utils.upload;
/**
 * 文件上传表单vo类
 * @ClassName: FileEntry
 * @author WFP
 * @date 2018年3月18日 下午3:45:56
 * @Description: TODO
 *
 */
public class FormData {
	
	private String name;	//属性名
	private String value;	//属性值
	private boolean isFile;	//是否是文件类型
	
	//文件类型
	private String fileType;	//文件类型
	private String fileName;	//文件名
	private String filePath;	//文件路径
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public boolean isFile() {
		return isFile;
	}
	public void setFile(boolean isFile) {
		this.isFile = isFile;
	}
	
	
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	@Override
	public String toString() {
		return "FormData [name=" + name + ", value=" + value + ", isFile=" + isFile + ", fileType=" + fileType
				+ ", fileName=" + fileName + ", filePath=" + filePath + "]";
	}
	
	
	
	
	
}
