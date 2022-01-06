CREATE TABLE IF NOT EXISTS `emsmdtdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `information` longtext DEFAULT NULL,
  `tags` longtext DEFAULT NULL,
  `gallery` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `ems_bulletin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `desc` mediumtext NOT NULL,
  `author` text NOT NULL,
  `time` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `ems_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `tags` longtext DEFAULT NULL,
  `officersinvolved` longtext DEFAULT NULL,
  `civsinvolved` longtext DEFAULT NULL,
  `gallery` longtext DEFAULT NULL,
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `individual` varchar(50) DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `tags` longtext DEFAULT NULL,
  `gallery` longtext DEFAULT NULL,
  `officersinvolved` longtext DEFAULT NULL,
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_bulletin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` tinytext DEFAULT NULL,
  `desc` mediumtext DEFAULT NULL,
  `author` tinytext DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_convictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `linkedincident` int(11) NOT NULL DEFAULT 0,
  `warrant` varchar(50) DEFAULT NULL,
  `guilty` varchar(50) DEFAULT NULL,
  `processed` varchar(50) DEFAULT NULL,
  `associated` varchar(50) DEFAULT '0',
  `charges` longtext DEFAULT NULL,
  `fine` int(11) DEFAULT 0,
  `sentence` int(11) DEFAULT 0,
  `recfine` int(11) DEFAULT 0,
  `recsentence` int(11) DEFAULT 0,
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(50) NOT NULL DEFAULT '0',
  `details` longtext CHARACTER SET utf8mb4 NOT NULL,
  `tags` longtext NOT NULL,
  `officersinvolved` longtext NOT NULL,
  `civsinvolved` longtext NOT NULL,
  `evidence` longtext NOT NULL,
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL DEFAULT '',
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(50) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `tags` longtext DEFAULT NULL,
  `officersinvolved` longtext DEFAULT NULL,
  `civsinvolved` longtext DEFAULT NULL,
  `gallery` longtext DEFAULT NULL,
  `time` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `pd_vehicleinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) DEFAULT NULL,
  `information` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `policemdtdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tags` longtext DEFAULT '[]',
  `gallery` longtext DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `owned_vehicles` ADD COLUMN `image` LONGTEXT NULL DEFAULT NULL AFTER `garage`;
