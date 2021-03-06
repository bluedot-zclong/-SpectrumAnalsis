/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : spectrumanalysis

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2018-04-14 16:18:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for algorithm
-- ----------------------------
DROP TABLE IF EXISTS `algorithm`;
CREATE TABLE `algorithm` (
  `algorithm_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增，算法的主键',
  `algorithm_version` int(16) NOT NULL COMMENT '算法编号16位 （20170101XXXXXXXX）后面为uuid,防止重复',
  `algorithm_name` varchar(10) NOT NULL COMMENT '用户上传时所命名（可修改）',
  `algorithm_sort` tinyint(1) NOT NULL COMMENT '算法类别,0代表预处理算法、1代表分析算法',
  `algorithm_uploadtime` datetime NOT NULL COMMENT '算法上传时间',
  `algorithm_dscription` varchar(512) DEFAULT NULL COMMENT '上传时对算法的描述（可修改)',
  `algorithm_language` varchar(8) NOT NULL COMMENT '算法语言类型',
  `algorithm_real_path` varchar(225) NOT NULL COMMENT '算法本地文件路径',
  `dir_file_id` bigint(20) unsigned NOT NULL COMMENT '文件夹id',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除状态，0代表未删除，1代表在回收站，2代表彻底删除',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`algorithm_id`),
  KEY `fk_algorithm_dir_file` (`dir_file_id`),
  CONSTRAINT `fk_algorithm_dir_file` FOREIGN KEY (`dir_file_id`) REFERENCES `dir` (`dir_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='算法信息表';

-- ----------------------------
-- Records of algorithm
-- ----------------------------

-- ----------------------------
-- Table structure for apply
-- ----------------------------
DROP TABLE IF EXISTS `apply`;
CREATE TABLE `apply` (
  `apply_id` bigint(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '申请编号',
  `apply_object_id` int(10) DEFAULT NULL COMMENT '对应的申请对象的id',
  `apply_type` tinyint(1) DEFAULT NULL COMMENT '申请类型,0代表角色申请,1代表解冻申请,2代表光谱申请,3代表检验线申请，4代表操作人员的光谱申请',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '申请人',
  `apply_file_url` varchar(255) DEFAULT NULL COMMENT '申请文件',
  `apply_time` datetime NOT NULL COMMENT '申请时间',
  `apply_status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '审核状态,0代表拒绝，1代表通过，2代表待审核，3代表操作人员申请光谱的待审核状态',
  `check_time` datetime DEFAULT NULL COMMENT '审核时间',
  `apply_content` varchar(255) DEFAULT NULL COMMENT '申请账号解封理由',
  `apply_reason` varchar(255) DEFAULT NULL COMMENT '审核批注',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`apply_id`),
  KEY `fk_apply_user_id` (`user_id`),
  CONSTRAINT `fk_apply_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='申请表(所有申请表)';

-- ----------------------------
-- Records of apply
-- ----------------------------

-- ----------------------------
-- Table structure for connection_algorithm
-- ----------------------------
DROP TABLE IF EXISTS `connection_algorithm`;
CREATE TABLE `connection_algorithm` (
  `connection_algorithm_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '组合线id，主键',
  `connection_algorithm_version` int(16) unsigned NOT NULL COMMENT '检验线组合编号（20170101XXXXXXXX）后面为uuid,防止重复',
  `hardware_id` bigint(20) unsigned NOT NULL COMMENT '硬件ID(在硬件类型表和光谱类型表合并后放光谱类型名字)',
  `connection_algorithm_name` varchar(16) NOT NULL COMMENT '检验线名称',
  `analysis_algorithm_id` bigint(20) unsigned NOT NULL COMMENT '分析算法ID(算法id外键)',
  `pretreatment_algorithm_id` bigint(20) unsigned NOT NULL COMMENT '预处理算法ID(算法id外键)',
  `standard_name` varchar(8) NOT NULL COMMENT '国际标准，如国标',
  `connection_algorithm_state` tinyint(1) NOT NULL COMMENT '检验线组合状态，0代表未开、1代表公开、2代表审核中、3代表已删除',
  `connection_algorithm_describe` varchar(512) DEFAULT NULL COMMENT '组合线描述',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户id',
  `connection_algorithm_save_time` datetime NOT NULL,
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`connection_algorithm_id`),
  KEY `fk_connection_algorithm_hardware_id` (`hardware_id`),
  KEY `fk_connection_algorithm_analysis_algorithm_id` (`analysis_algorithm_id`),
  KEY `fk_connection_algorithm_pretreatment_algorithm_id` (`pretreatment_algorithm_id`),
  KEY `fk_connection_algorithm_pretreatment_algorithm_user_id` (`user_id`),
  CONSTRAINT `fk_connection_algorithm_analysis_algorithm_id` FOREIGN KEY (`analysis_algorithm_id`) REFERENCES `algorithm` (`algorithm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_connection_algorithm_hardware_id` FOREIGN KEY (`hardware_id`) REFERENCES `hardware` (`hardware_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_connection_algorithm_pretreatment_algorithm_id` FOREIGN KEY (`pretreatment_algorithm_id`) REFERENCES `algorithm` (`algorithm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_connection_algorithm_pretreatment_algorithm_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检测线表';

-- ----------------------------
-- Records of connection_algorithm
-- ----------------------------

-- ----------------------------
-- Table structure for connection_algorithm_detected_object
-- ----------------------------
DROP TABLE IF EXISTS `connection_algorithm_detected_object`;
CREATE TABLE `connection_algorithm_detected_object` (
  `cado_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection_algorithm_id` bigint(20) unsigned NOT NULL COMMENT '检验线组合id,做外键',
  `detected_objects_id` bigint(20) unsigned NOT NULL COMMENT '被检测物id',
  PRIMARY KEY (`cado_id`),
  KEY `fk_connection_algorithm_id` (`connection_algorithm_id`),
  KEY `fk_detected_objects_id` (`detected_objects_id`),
  CONSTRAINT `fk_connection_algorithm_id` FOREIGN KEY (`connection_algorithm_id`) REFERENCES `connection_algorithm` (`connection_algorithm_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detected_objects_id` FOREIGN KEY (`detected_objects_id`) REFERENCES `detected_object` (`detected_objects_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检测线-被检测物表';

-- ----------------------------
-- Records of connection_algorithm_detected_object
-- ----------------------------

-- ----------------------------
-- Table structure for connection_algorithm_detection_material
-- ----------------------------
DROP TABLE IF EXISTS `connection_algorithm_detection_material`;
CREATE TABLE `connection_algorithm_detection_material` (
  `cadm_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cado_id` bigint(20) unsigned NOT NULL COMMENT '检验线-被检测物id做外键',
  `detection_material_name` varchar(50) NOT NULL COMMENT '检测内容名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`cadm_id`),
  KEY `fk_cado_id` (`cado_id`),
  CONSTRAINT `fk_cado_id` FOREIGN KEY (`cado_id`) REFERENCES `connection_algorithm_detected_object` (`cado_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检验线-检测内容表';

-- ----------------------------
-- Records of connection_algorithm_detection_material
-- ----------------------------

-- ----------------------------
-- Table structure for detected_category
-- ----------------------------
DROP TABLE IF EXISTS `detected_category`;
CREATE TABLE `detected_category` (
  `detected_type_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '被检测物分类编号',
  `first_classification` varchar(32) DEFAULT NULL COMMENT '被检测物的一级分类',
  `secondary_classification_id` int(8) DEFAULT NULL COMMENT '二级分类的类别编号',
  `secondary_classification` varchar(32) DEFAULT NULL COMMENT '二级分类名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`detected_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='被检测物分类表';

-- ----------------------------
-- Records of detected_category
-- ----------------------------
INSERT INTO `detected_category` VALUES ('1', null, null, null, '2018-04-14 14:20:12', '0000-00-00 00:00:00');

-- ----------------------------
-- Table structure for detected_object
-- ----------------------------
DROP TABLE IF EXISTS `detected_object`;
CREATE TABLE `detected_object` (
  `detected_objects_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '被检测物编号',
  `detected_type_id` bigint(20) NOT NULL COMMENT '被检测物分类编号',
  `detected_objects_name` varchar(32) NOT NULL COMMENT '被检测物名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`detected_objects_id`),
  KEY `fk_detected_type_id` (`detected_type_id`),
  CONSTRAINT `fk_detected_type_id` FOREIGN KEY (`detected_type_id`) REFERENCES `detected_category` (`detected_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='被检测物表';

-- ----------------------------
-- Records of detected_object
-- ----------------------------
INSERT INTO `detected_object` VALUES ('1', '1', '123', '2018-04-14 14:20:24', '0000-00-00 00:00:00');

-- ----------------------------
-- Table structure for detection_material
-- ----------------------------
DROP TABLE IF EXISTS `detection_material`;
CREATE TABLE `detection_material` (
  `detection_material_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '检测内容编号',
  `category_id` bigint(20) NOT NULL COMMENT '内容类别编号',
  `detection_material_name` varchar(32) NOT NULL COMMENT '检测内容名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`detection_material_id`),
  KEY `fk_category_id` (`category_id`),
  CONSTRAINT `fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `detection_material_category` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检测的内容表';

-- ----------------------------
-- Records of detection_material
-- ----------------------------

-- ----------------------------
-- Table structure for detection_material_category
-- ----------------------------
DROP TABLE IF EXISTS `detection_material_category`;
CREATE TABLE `detection_material_category` (
  `category_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '检测内容类别编号',
  `category__name` varchar(32) NOT NULL COMMENT '类别名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检测内容分类表';

-- ----------------------------
-- Records of detection_material_category
-- ----------------------------

-- ----------------------------
-- Table structure for detection_material_detail
-- ----------------------------
DROP TABLE IF EXISTS `detection_material_detail`;
CREATE TABLE `detection_material_detail` (
  `material_detail_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '检测物质细节id',
  `report_id` bigint(20) unsigned NOT NULL COMMENT '报告ID',
  `material_name` varchar(50) NOT NULL COMMENT '检测的内容如：性激素、毒素、重金属等(换成json串)',
  `material_value` varchar(50) NOT NULL COMMENT '数据值',
  `standard_value` varchar(50) NOT NULL COMMENT '标准数据对应值',
  `is_excessive` tinyint(1) NOT NULL COMMENT '该检测内容含量是否超标，0表示未超标，1表示超标',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`material_detail_id`),
  KEY `fk_report_id` (`report_id`),
  CONSTRAINT `fk_report_id` FOREIGN KEY (`report_id`) REFERENCES `report` (`report_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='检测物质细节表';

-- ----------------------------
-- Records of detection_material_detail
-- ----------------------------

-- ----------------------------
-- Table structure for dir
-- ----------------------------
DROP TABLE IF EXISTS `dir`;
CREATE TABLE `dir` (
  `dir_id` bigint(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `dir_name` varchar(20) NOT NULL COMMENT '文件夹名称',
  `dir_type_id` tinyint(1) NOT NULL DEFAULT '0' COMMENT '文件夹所属类型，0表示光谱文件夹，1表示算法文件',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`dir_id`),
  KEY `fk_user_id` (`user_id`),
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='光谱/算法文件夹';

-- ----------------------------
-- Records of dir
-- ----------------------------
INSERT INTO `dir` VALUES ('2', '3', 'adsasdas', '0', '2018-03-17 17:40:27', '2018-04-14 16:13:48');
INSERT INTO `dir` VALUES ('3', '3', 'adasdsd', '1', '2018-03-17 17:41:41', '2018-04-14 16:09:46');
INSERT INTO `dir` VALUES ('4', '3', 'qqqq', '0', '2018-03-17 17:41:49', '2018-03-17 17:41:49');
INSERT INTO `dir` VALUES ('5', '3', '1231', '0', '2018-04-14 10:15:06', '2018-04-14 10:15:06');

-- ----------------------------
-- Table structure for function
-- ----------------------------
DROP TABLE IF EXISTS `function`;
CREATE TABLE `function` (
  `function_id` bigint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '功能编号',
  `function_name` varchar(32) DEFAULT NULL COMMENT '功能名称',
  `function_url` varchar(64) DEFAULT NULL COMMENT '功能的地址',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`function_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='功能表';

-- ----------------------------
-- Records of function
-- ----------------------------

-- ----------------------------
-- Table structure for hardware
-- ----------------------------
DROP TABLE IF EXISTS `hardware`;
CREATE TABLE `hardware` (
  `hardware_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '设备编号',
  `hardware_type` varchar(16) DEFAULT NULL COMMENT '硬件类型',
  `hardware_name` varchar(64) NOT NULL COMMENT '设备名称',
  `spectrum_type_id` bigint(20) unsigned NOT NULL COMMENT '硬件支持的光谱编号唯一不能重复',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可用（1：表示可用，0：表示不可用）',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`hardware_id`),
  KEY `fk_spectrum_type_id` (`spectrum_type_id`),
  CONSTRAINT `fk_spectrum_type_id` FOREIGN KEY (`spectrum_type_id`) REFERENCES `spectrum_type` (`spectrumtype_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='硬件信息';

-- ----------------------------
-- Records of hardware
-- ----------------------------
INSERT INTO `hardware` VALUES ('1', '', 'PerkinElmer 红外光谱仪Spectrum Two', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('2', null, 'Q1000手持式油液状态监控仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('3', null, 'WQF-510A傅立叶变换红外光谱仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('4', null, '傅立叶变换红外光谱仪FTIR-650', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('5', null, '安捷伦4500增塑剂检测专用分析仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('6', null, 'Nicolet iS50 傅立叶变换红外光谱仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('7', null, 'WQF-520A傅立叶变换红外光谱仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('8', null, 'Nicolet iS10 傅立叶变换红外光谱仪', '1', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('9', null, '海洋光学IDRaman mini 手持式拉曼系统', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('10', null, '钢研纳克smart便携式的台式拉曼光谱仪', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('11', null, 'DXR 智能拉曼光谱仪', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('12', null, '手持式拉曼光谱仪TruScan RM', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('13', null, 'Cobalt RapID空间位移拉曼光谱仪', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('14', null, 'Kaiser拉曼在线生物工艺分析仪', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('15', null, 'NanoRam手持式拉曼鉴定系统', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('16', null, '全自动拉曼光谱仪-XploRA PLUS', '4', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('17', null, '﻿AFS-9780全自动四灯位注射式氢化物发生原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('18', null, 'DCMA-200型直接进样汞镉测试仪', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('19', null, 'RGF¬8780原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('20', null, 'SK-博析-LC 液相色谱原子荧光联用仪', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('21', null, 'AFS-9700全自动注射泵原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('22', null, 'AFS-9130型全自动内置式顺序注射原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('23', null, 'AF-7500型原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('24', null, 'AFS-9330型全自动六灯位顺序注射原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('25', null, 'DCMA-200型直接进样汞镉测试仪', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('26', null, 'RGF¬8780原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('27', null, 'SK-博析-LC 液相色谱原子荧光联用仪', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('28', null, 'AF-7500型原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('29', null, 'AFS-9780全自动四灯位注射式氢化物发生原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('30', null, 'AF-7550型双道氢化物-原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('31', null, 'AFS-9330型全自动六灯位顺序注射原子荧光光度计', '5', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('32', null, 'AFS-9700全自动注射泵原子荧光光度计', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('33', null, 'PerkinElmer 原子吸收光谱仪', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('34', null, '耶拿ZEEnit®700P火焰石墨炉原子吸收光谱仪', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('35', null, 'AA－7020型原子吸收分光光度计', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('36', null, '原子吸收分光光度计AA-7000', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('37', null, '仪电科仪 4510F原子吸收分光光度计', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('38', null, 'WFX-210原子吸收分光光度计', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('39', null, 'TAS-990原子吸收分光光度计', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('40', null, 'WFX-910便携式原子吸收光谱仪', '6', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('41', null, '聚光ICP-5000电感耦合等离子体发射光谱仪', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('42', null, 'PQ9000 高分辨率ICP-OES', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('43', null, 'PerkinElmer Optima 8000 等离子体发射光谱仪', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('44', null, 'Plasma 2000 全谱电感耦合等离子光谱仪', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('45', null, 'Prodigy7 等离子体发射光谱仪', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('46', null, '赛默飞 iCAP 7000 系列 ICP-OES', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('47', null, 'ICP发射光谱仪ICPS-8100', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('48', null, '5100 ICP-OES', '7', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('49', null, 'F97系列荧光分光光度计', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('50', null, '同步吸收-三维荧光扫描光谱仪Aqualog®', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('51', null, '爱丁堡一体化稳态瞬态荧光光谱仪FS5', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('52', null, '岛津荧光分光光度计 RF-6000', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('53', null, '超快时间分辨荧光光谱仪DeltaFlex', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('54', null, '荧光分光光度计F-380', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('55', null, '高灵敏一体式荧光光谱仪-FluoroMax-4', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('56', null, 'F96S高速荧光分光光度计', '8', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('57', null, 'SparkCCD 6000 火花直读光谱仪', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('58', null, '德国OBLF GS1000-II型直读光谱仪', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('59', null, '台式直读光谱仪FOUNDRY-MASTER Smart', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('60', null, 'ARL easySpark 全谱直读光谱仪', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('61', null, '岛津光电直读光谱仪 PDA-5000', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('62', null, '火花直读光谱仪1000型', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('63', null, 'M5000 CCD全谱直读光谱仪', '9', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('64', null, '岛津光电发射光谱仪PDA-8000', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('65', null, '聚光科技 SupNIR¬2700系列近红外分析仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('66', null, '海能仪器 Spectrastar2500XL系列近红外光谱仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('67', null, '福斯NIRS DS 2500 多功能近红外分析仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('68', null, '[海洋光学]NIRQUEST近红外光谱仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('69', null, 'VIAVI MicroNIR Pro微型近红外光谱仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('70', null, '瑞士万通_DS 2500 近红外光谱分析仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('71', null, '瑞士万通PRO 近红外在线分析仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('72', null, 'XDS SmartProbe 近红外光谱分析仪', '2', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('73', null, '影像校正光谱仪 OmniEvo180“优雅型”', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('74', null, '193mm焦距高光通量影像校正光栅光谱仪-SR193i', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('75', null, '真空紫外光栅光谱仪', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('76', null, 'iHR320/iHR550成像光谱仪', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('77', null, 'FHR640/FHR1000光谱仪', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('78', null, '紫外可见便携式光谱仪OL756', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('79', null, 'Horiba 多功能成像高分辨光谱仪（iHR550）', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');
INSERT INTO `hardware` VALUES ('80', null, '7IGF10定光栅摄谱仪，光谱仪', '10', '0', '2018-04-14 16:03:10', '2018-03-17 17:41:20');

-- ----------------------------
-- Table structure for maintenance
-- ----------------------------
DROP TABLE IF EXISTS `maintenance`;
CREATE TABLE `maintenance` (
  `maintenance_id` bigint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '维护编号',
  `maintenance_name` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '维护名称',
  `maintenance_type` tinyint(1) DEFAULT NULL COMMENT '0代表备份  1代表恢复',
  `maintenance_content` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '备份/恢复的内容',
  `maintenance_describe` varchar(64) CHARACTER SET utf8 DEFAULT NULL COMMENT '维护/备份的描述',
  `maintenance_file_address` varchar(256) CHARACTER SET utf8 DEFAULT NULL COMMENT '操作是备份时,备份文件的路径(恢复没有)',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`maintenance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='系统维护表。恢复和备份,备份为0，恢复为1';

-- ----------------------------
-- Records of maintenance
-- ----------------------------

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `report_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '光谱分析报告编号',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户编号',
  `spectrum_type_name` varchar(16) NOT NULL COMMENT '光谱类型名',
  `check_time` datetime NOT NULL COMMENT '检测时间',
  `standard_content` varchar(16) NOT NULL COMMENT '标准含量',
  `standards` varchar(4) NOT NULL COMMENT '执行标准',
  `unit` varchar(4) NOT NULL COMMENT '单位',
  `regular` int(2) NOT NULL COMMENT '是否合格，0表示合格，1表示不合格',
  `limit` varchar(2) NOT NULL COMMENT '是否超标',
  `spectruminfo_id` bigint(20) unsigned NOT NULL COMMENT '光谱的主键编号',
  `detected_name` varchar(20) NOT NULL COMMENT '被检测物名字',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后修改时间',
  PRIMARY KEY (`report_id`),
  KEY `fk_report_user_id` (`user_id`),
  KEY `fk_spectruminfo_id` (`spectruminfo_id`),
  CONSTRAINT `fk_report_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_spectruminfo_id` FOREIGN KEY (`spectruminfo_id`) REFERENCES `spectruminfo` (`spectruminfo_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='光谱分析报告表';

-- ----------------------------
-- Records of report
-- ----------------------------

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_id` bigint(2) unsigned NOT NULL AUTO_INCREMENT COMMENT '角色编号',
  `role_name` varchar(12) NOT NULL COMMENT '角色名',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后修改时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '普通用户', '2018-01-26 15:20:54', '2018-01-26 15:20:57');
INSERT INTO `role` VALUES ('2', '操作人员', '2018-01-26 15:21:02', '2018-01-26 15:21:05');
INSERT INTO `role` VALUES ('3', '实验人员', '2018-01-26 15:21:08', '2018-01-26 15:21:10');
INSERT INTO `role` VALUES ('4', '普通管理员', '2018-01-26 15:21:12', '2018-01-26 15:21:14');
INSERT INTO `role` VALUES ('5', '超级管理员', '2018-01-26 15:21:17', '2018-01-26 15:21:21');

-- ----------------------------
-- Table structure for role_function
-- ----------------------------
DROP TABLE IF EXISTS `role_function`;
CREATE TABLE `role_function` (
  `role_function_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint(2) unsigned NOT NULL COMMENT '角色编号',
  `function_id` bigint(5) unsigned NOT NULL COMMENT '功能编号',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`role_function_id`),
  KEY `fk_role_id` (`role_id`),
  KEY `fk_function_id` (`function_id`),
  CONSTRAINT `fk_function_id` FOREIGN KEY (`function_id`) REFERENCES `function` (`function_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色-功能联系表';

-- ----------------------------
-- Records of role_function
-- ----------------------------

-- ----------------------------
-- Table structure for spectruminfo
-- ----------------------------
DROP TABLE IF EXISTS `spectruminfo`;
CREATE TABLE `spectruminfo` (
  `spectruminfo_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `spectrum_version` int(16) NOT NULL COMMENT '光谱版本号（20170101XXXXXXXX）后面为uuid,防止重复',
  `is_standard_spectrum` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为标准光谱（0不是，1是）',
  `spectrum_name` varchar(16) NOT NULL COMMENT '光谱名字',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除，0代表未删除，1代表在回收站，2代表彻底删除，默认为0',
  `save_time` datetime(6) NOT NULL COMMENT '光谱保存时间',
  `spectrum_description` varchar(128) NOT NULL COMMENT '光谱描述',
  `characteristic_peak` text COMMENT '光谱特征峰值',
  `spectrum_file_url` varchar(255) NOT NULL COMMENT '光谱文件保存地址',
  `category_origin` varchar(32) NOT NULL COMMENT '被检测物产地',
  `detected_id` bigint(20) unsigned NOT NULL COMMENT '被检测物编号(外键)',
  `file_id` bigint(20) unsigned NOT NULL COMMENT '文件夹编号(外键)',
  `hardware_name` varchar(64) DEFAULT NULL COMMENT '硬件名称',
  `spectrum_type_name` varchar(20) NOT NULL COMMENT '光谱类型名称',
  `spectrum_picture_url` varchar(255) DEFAULT NULL COMMENT '光谱图片',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`spectruminfo_id`),
  KEY `fk_detected_id` (`detected_id`),
  KEY `fk_file_id` (`file_id`),
  CONSTRAINT `fk_detected_id` FOREIGN KEY (`detected_id`) REFERENCES `detected_object` (`detected_objects_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_file_id` FOREIGN KEY (`file_id`) REFERENCES `dir` (`dir_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='光谱信息表';

-- ----------------------------
-- Records of spectruminfo
-- ----------------------------
INSERT INTO `spectruminfo` VALUES ('1', '1', '0', '光谱一号', '0', '2018-04-14 14:17:34.000000', '这是光谱', null, 'asd', 'qwe', '1', '2', '红外', '红外', 'sad', '2018-04-14 14:20:28', '2018-04-14 14:39:03');

-- ----------------------------
-- Table structure for spectrum_type
-- ----------------------------
DROP TABLE IF EXISTS `spectrum_type`;
CREATE TABLE `spectrum_type` (
  `spectrumtype_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '光谱类型编号',
  `spectrumtype_name` varchar(16) NOT NULL COMMENT '光谱类型',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`spectrumtype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='光谱类型表';

-- ----------------------------
-- Records of spectrum_type
-- ----------------------------
INSERT INTO `spectrum_type` VALUES ('1', '红外光谱', '2018-04-14 15:57:00', '2018-04-03 15:59:38');
INSERT INTO `spectrum_type` VALUES ('2', '近红外光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('3', '远红外光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('4', '激光拉曼光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('5', '原子荧光光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('6', '原子吸光光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('7', 'ICP-AES原子发射光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('8', '分子荧光光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('9', '光电直读关光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('10', '光栅光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('11', '圆二色光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('12', '辉光放电光谱', '2018-04-14 15:57:00', '2018-04-26 15:59:41');
INSERT INTO `spectrum_type` VALUES ('13', '来了', '2018-04-14 15:57:00', '2018-04-26 15:59:41');

-- ----------------------------
-- Table structure for standard
-- ----------------------------
DROP TABLE IF EXISTS `standard`;
CREATE TABLE `standard` (
  `standard_id` bigint(2) unsigned NOT NULL AUTO_INCREMENT,
  `standard_name` varchar(10) NOT NULL COMMENT '标准名称（国标，欧标）',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`standard_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='国际标准表';

-- ----------------------------
-- Records of standard
-- ----------------------------

-- ----------------------------
-- Table structure for standard_spectrum
-- ----------------------------
DROP TABLE IF EXISTS `standard_spectrum`;
CREATE TABLE `standard_spectrum` (
  `standard_spectrum_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '编号',
  `standard_spectrum_version` int(16) NOT NULL COMMENT '标准光谱编号',
  `standard_spectrum_name` varchar(16) NOT NULL COMMENT '光谱名字',
  `save_time` datetime(6) NOT NULL COMMENT '光谱保存时间',
  `spectrum_description` varchar(128) NOT NULL COMMENT '光谱描述',
  `characteristic_peak` text NOT NULL COMMENT '光谱特征峰值',
  `spectrum_file_url` varchar(255) NOT NULL COMMENT '光谱文件保存地址',
  `category_origin` varchar(32) NOT NULL COMMENT '被检测物产地',
  `detected_id` bigint(20) unsigned NOT NULL COMMENT '被检测物编号',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户编号',
  `spectrum_picture_url` varchar(255) NOT NULL COMMENT '光谱图片路径',
  `spectrum_type_name` varchar(20) NOT NULL COMMENT '光谱类型名称',
  `hardware_name` varchar(64) NOT NULL COMMENT '硬件名称',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`standard_spectrum_id`),
  KEY `fk_standard_spectrum_user_id` (`user_id`),
  KEY `fk_standard_spectrum_detected_id` (`detected_id`),
  CONSTRAINT `fk_standard_spectrum_detected_id` FOREIGN KEY (`detected_id`) REFERENCES `detected_object` (`detected_objects_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_standard_spectrum_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标准光谱信息表';

-- ----------------------------
-- Records of standard_spectrum
-- ----------------------------

-- ----------------------------
-- Table structure for syslog
-- ----------------------------
DROP TABLE IF EXISTS `syslog`;
CREATE TABLE `syslog` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户编号',
  `ip` varchar(16) NOT NULL COMMENT '用户ip地址',
  `opetate_content` varchar(32) NOT NULL COMMENT '操作具体内容',
  `log_lever` varchar(10) NOT NULL COMMENT '操作级别',
  `function_id` bigint(20) NOT NULL COMMENT '功能编号',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`log_id`)
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8 COMMENT='日志管理';

-- ----------------------------
-- Records of syslog
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(16) NOT NULL COMMENT '用户真实姓名',
  `password` varchar(32) NOT NULL COMMENT '密码',
  `salt` varchar(64) DEFAULT NULL COMMENT '进行加密的盐值',
  `idcard` char(18) DEFAULT NULL COMMENT '非普通用户必填，以后不可修改(申请角色是必填)',
  `phone_number` char(11) NOT NULL COMMENT '手机号',
  `email` varchar(32) NOT NULL COMMENT '邮箱（根据邮箱登录）',
  `birthday` date DEFAULT NULL COMMENT '生日(选填)',
  `sex` tinyint(1) NOT NULL COMMENT '1:男，0：女',
  `photo_url` varchar(255) NOT NULL COMMENT '用户头像路径',
  `person_address` varchar(128) DEFAULT NULL COMMENT '个人地址（选填，申请完善）',
  `work_address` varchar(64) DEFAULT NULL COMMENT '工作地址（选填，申请完善）',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '账号状态(正常在线对应1,正常离线对应2,冻结对应0)',
  `role_id` bigint(2) unsigned NOT NULL DEFAULT '1' COMMENT '普通用户对应1 操作人员对应2 实验人员对应3 普通管理员对应4超级管理员对应5',
  `gmt_create` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后修改时间',
  PRIMARY KEY (`user_id`),
  KEY `fk_user_roleId` (`role_id`),
  CONSTRAINT `fk_user_roleId` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'user', '7f7cd15807fa0e4b278181e1f99767a1', 'qwer', '362502201701011234', '15797957730', 'user@qq.com', '2018-01-26', '1', '', '', '', '2', '1', '2018-01-26 15:20:24', '2018-01-26 15:20:26');
INSERT INTO `user` VALUES ('2', 'operator', '7f7cd15807fa0e4b278181e1f99767a1', 'qwer', '362502201701011234', '15797957730', 'operator@qq.com', '2018-01-26', '1', '', '', '', '2', '2', '2018-01-26 15:20:24', '2018-01-26 15:20:26');
INSERT INTO `user` VALUES ('3', 'lab', '7f7cd15807fa0e4b278181e1f99767a1', 'qwer', '362502201701011234', '15797957730', 'lab@qq.com', '2018-01-26', '1', '', '', '', '2', '3', '2018-01-26 15:20:24', '2018-01-26 15:20:26');
INSERT INTO `user` VALUES ('4', 'admin', '7f7cd15807fa0e4b278181e1f99767a1', 'qwer', '362502201701011234', '15797957730', 'admin@qq.com', '2018-01-26', '1', '', '', '', '2', '4', '2018-01-26 15:20:24', '2018-01-26 15:20:26');
INSERT INTO `user` VALUES ('5', 'superadmin', '7f7cd15807fa0e4b278181e1f99767a1', 'qwer', '362502201701011234', '15797957730', 'superadmin@qq.com', '2018-01-26', '1', '', '', '', '2', '5', '2018-01-26 15:20:24', '2018-01-26 15:20:26');

-- ----------------------------
-- Table structure for userdir_mv
-- ----------------------------
DROP TABLE IF EXISTS `userdir_mv`;
CREATE TABLE `userdir_mv` (
  `user_id` bigint(20) DEFAULT NULL,
  `user_name` varchar(16) DEFAULT NULL,
  `dir_id` bigint(20) DEFAULT NULL,
  `dir_name` varchar(20) DEFAULT NULL,
  `dir_type_id` tinyint(255) DEFAULT NULL,
  `gmt_create` timestamp NULL DEFAULT NULL,
  `gmt_modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表和文件夹表的物化视图表';

-- ----------------------------
-- Records of userdir_mv
-- ----------------------------

-- ----------------------------
-- Event structure for addheardware
-- ----------------------------
DROP EVENT IF EXISTS `addheardware`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `addheardware` ON SCHEDULE AT '2018-04-14 15:03:02' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO `spectrumanalysis`.`hardware` (`hardware_id`, `hardware_type`, `hardware_name`, `spectrum_type_id`, `gmt_create`) VALUES ('1', '', 'PerkinElmer 红外光谱仪Spectrum Two', '1', '2017-01-20 13:55:14');
;;
DELIMITER ;

-- ----------------------------
-- Event structure for addSpectrum_type
-- ----------------------------
DROP EVENT IF EXISTS `addSpectrum_type`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `addSpectrum_type` ON SCHEDULE AT '2018-04-14 15:51:29' ON COMPLETION NOT PRESERVE ENABLE DO INSERT INTO `spectrumanalysis`.`spectrum_type` (`spectrumtype_name_id`, `spectrumtype_name`) VALUES ('1', '红外光谱');
;;
DELIMITER ;
