package bluedot.spectrum.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bluedot.spectrum.common.EditObject;
import bluedot.spectrum.common.QueryObject;
import bluedot.spectrum.commons.entity.Algorithm;
import bluedot.spectrum.commons.entity.Dir;
import bluedot.spectrum.commons.entity.Spectruminfo;
import bluedot.spectrum.commons.entity.User;
import bluedot.spectrum.service.EditService;
import bluedot.spectrum.service.QueryService;
import bluedot.spectrum.web.core.ModelAndView;
import jxau.spectrum.frame.web.annotation.Autowired;
import jxau.spectrum.frame.web.annotation.Controller;
import jxau.spectrum.frame.web.annotation.RequestMapping;
import jxau.spectrum.frame.web.annotation.RequestParam;

/**
 * 文件夹业务
 * @author Aaron
 * 2018年1月20日
 */
@Controller
@RequestMapping("/dir")
public class DirController extends BaseController {
	
	@Autowired
	private QueryService queryService;
	@Autowired
	private EditService editService;
	/**
	 * 查询（光谱/算法）文件夹---ajax请求
	 * Aaron
	 * @param req
	 * @param resp
	 * @return
	 * 2018年1月21日
	 */
	@RequestMapping("/query/ajax")
	public Object queryDirAjax (HttpServletRequest req, HttpServletResponse resp){
	
        return renderSuccess();
	}
	/**
	 * 查询（光谱/算法）文件夹---普通请求
	 * Aaron
	 * @param req
	 * @param resp
	 * @return
	 * 2018年1月21日
	 */
	@RequestMapping("/query")
	public Object queryDir (@RequestParam("dirtype")Integer dirtype,@RequestParam("start")Integer start,@RequestParam("end")Integer end,HttpServletRequest req, HttpServletResponse resp){
		//传给模板用来存储数据的model
        Map<String, Object> model = new HashMap<String, Object>();
        ModelAndView modelAndView = new ModelAndView();
        //往model中添加数据
        User user = (User)req.getSession().getAttribute("userSession");
        Map<String,Object> condition = new HashMap<>();
        condition.put("user_id", user.getUserId());
        condition.put("dir_type_id", dirtype);
        QueryObject queryParm = new QueryObject("dir", condition, start, end, null);
        List<HashMap<String,Object>> queryResult = queryService.query(queryParm);
        List<Dir> dirInfoList  = getBeanList(queryResult, Dir.class);
        modelAndView.addObject(dirInfoList);
        if(dirtype==1){
        	modelAndView.addObject("fileType", "1");
        	modelAndView.setViewName("/dir/algorithmdir");
        }else{
        	modelAndView.addObject("fileType", "0");
        	modelAndView.setViewName("/dir/spectrumdir");
        }
        return modelAndView;
	}
	
	/**
	 * 更新（光谱/算法）文件夹
	 * Aaron
	 * @param req
	 * @param resp
	 * @return
	 * 2018年1月21日
	 */
	@RequestMapping("/update")
	public String updateDirAjax (@RequestParam("dirName")String dirName,@RequestParam("dirId")Integer dirId,@RequestParam("dirType") Integer dirType
			,HttpServletRequest req, HttpServletResponse resp){
        //往model中添加数据
        Map<String,Object> condition = new HashMap<>();
        condition.put("dir_id",dirId);
        Map<String,Object> updateMap = new HashMap<>();
        updateMap.put("dir_name", dirName);
        EditObject editParm = new EditObject("dir", updateMap, condition, null);
        int Result = editService.edit(editParm);
        if(dirType==0){
			return "redirect:/dir/query?dirtype=0&start=0&end=10";
		}else{
			return "redirect:/dir/query?dirtype=1&start=0&end=10";
		}
	}
	
	/**
	 * 删除（光谱/算法）文件夹---ajax请求
	 * Aaron
	 * @param req
	 * @param resp
	 * @return
	 * 2018年1月21日
	 */
	@RequestMapping("/delete/ajax")
	public Object deleteDirAjax (@RequestParam("dirId")Integer dirId,HttpServletRequest req, HttpServletResponse resp){
        Map<String,Object> condition = new HashMap<>();
        condition.put("dir_id",dirId);
        EditObject editParm = new EditObject("dir",condition, null);
        int Result = editService.edit(editParm);
        return renderSuccess("success");
        
	}
	/**
	 * 新建文件夹
	 * Aaron
	 * @param dirName
	 * @param req
	 * @param resp
	 * @return
	 */
	@RequestMapping("/create")
	public String createDir(@RequestParam("dirName")String dirName,@RequestParam("dirType")Integer dirType,HttpServletRequest req, HttpServletResponse resp){
		Map<String,Object> insert = new HashMap<>();
		insert.put("dir_type_id", dirType);
		insert.put("dir_name", dirName);
		User user = (User)req.getSession().getAttribute("userSession");
		insert.put("user_id", user.getUserId());
		EditObject editParm = new EditObject(insert, "dir"); 
		int Result = editService.edit(editParm);
		if(dirType==0){
			return "redirect:/dir/query?dirtype=0&start=0&end=10";
		}else{
			return "redirect:/dir/query?dirtype=1&start=0&end=10";
		}
	}
	
	
	
	@RequestMapping("/showAllFile")
	public ModelAndView showAllFile(@RequestParam("dirId")Integer dirId,@RequestParam("dirType")Integer dirType,HttpServletRequest req, HttpServletResponse resp){
		System.out.println(dirId);
		//传给模板用来存储数据的model
        Map<String, Object> model = new HashMap<String, Object>();
        ModelAndView modelAndView = new ModelAndView();
        //往model中添加数据
        User user = (User)req.getSession().getAttribute("userSession");
        Map<String,Object> condition = new HashMap<>();
        if(dirType.intValue()==0){
        	condition.put("file_id", dirId);
        	QueryObject queryParm = new QueryObject("spectruminfo", condition, null, null, null);
        	List<HashMap<String,Object>> queryResult = queryService.query(queryParm);
            List<Spectruminfo> spectrumList  = getBeanList(queryResult, Spectruminfo.class);
            modelAndView.addObject(spectrumList);
            modelAndView.addObject("dirId", dirId);
            modelAndView.setViewName("/spectrum/spectrum");
        }else{
        	condition.put("dir_file_id", dirId);
        	QueryObject queryParm = new QueryObject("algorithm", condition, null, null, null);
        	List<HashMap<String,Object>> queryResult = queryService.query(queryParm);
            List<Algorithm> algorithmList  = getBeanList(queryResult, Algorithm.class);
            modelAndView.addObject(algorithmList);
            modelAndView.addObject("dir_file_id", dirId);
            modelAndView.setViewName("/algorithm/algorithmFile");
        }
        return modelAndView;
	}
	
	
}
