package bluedot.spectrum.commons.entity;

import java.util.Date;

/**
 * DetectionMaterialCategory -> detection_material_category
 * 2018-01-21
 */
public class DetectionMaterialCategory {
    /**
     * 检测内容类别编号
     */
    private Long categoryId;

    /**
     * 类别名称
     */
    private String categoryName;

    /**
     * 创建时间
     */
    private Date gmtCreate;

    /**
     * 最后修改时间
     */
    private Date gmtModified;

    private static final long serialVersionUID = 1L;

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Date getGmtCreate() {
        return gmtCreate;
    }

    public void setGmtCreate(Date gmtCreate) {
        this.gmtCreate = gmtCreate;
    }

    public Date getGmtModified() {
        return gmtModified;
    }

    public void setGmtModified(Date gmtModified) {
        this.gmtModified = gmtModified;
    }

	@Override
	public String toString() {
		return "DetectionMaterialCategory [categoryId=" + categoryId + ", categoryName=" + categoryName + ", gmtCreate="
				+ gmtCreate + ", gmtModified=" + gmtModified + "]";
	}
    
}