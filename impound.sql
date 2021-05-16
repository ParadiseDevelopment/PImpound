CREATE TABLE IF NOT EXISTS `impound_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timeStamp` varchar(80) DEFAULT NULL,
  `impoundName` varchar(60) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `ownerCharname` varchar(50) DEFAULT NULL,
  `vehicleModel` varchar(50) DEFAULT NULL,
  `vehiclePlate` varchar(50) DEFAULT NULL,
  `vehicleProps` longtext DEFAULT NULL,
  `officer` varchar(50) DEFAULT NULL,
  `officerCharname` varchar(50) DEFAULT NULL,
  `cautionAllowed` tinyint(4) DEFAULT NULL,
  `caution` int(11) DEFAULT NULL,
  `vehicleType` varchar(50) DEFAULT NULL,
  `vehicleJob` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
