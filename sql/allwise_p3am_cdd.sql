CREATE TABLE `allwise_p3am_cdd` (

        `coadd_id`     VARCHAR(20)  DEFAULT NULL,
            `band`             INT  DEFAULT NULL,
           `naxis`             INT  DEFAULT NULL,
          `naxis1`             INT  DEFAULT NULL,
          `naxis2`             INT  DEFAULT NULL,
        `wrelease`     VARCHAR(20)  DEFAULT NULL,
          `crpix1`    DECIMAL(8,1)  DEFAULT NULL,
          `crpix2`    DECIMAL(8,1)  DEFAULT NULL,
          `crval1`  DECIMAL(15,12)  DEFAULT NULL,
          `crval2`  DECIMAL(15,12)  DEFAULT NULL,
          `ctype1`     VARCHAR(13)  DEFAULT NULL,
          `ctype2`     VARCHAR(13)  DEFAULT NULL,
         `equinox`    DECIMAL(5,1)  DEFAULT NULL,
           `bunit`     VARCHAR(20)  DEFAULT NULL,
            `elon`  DECIMAL(15,12)  DEFAULT NULL,
            `elat`  DECIMAL(15,12)  DEFAULT NULL,
            `glon`  DECIMAL(15,12)  DEFAULT NULL,
            `glat`  DECIMAL(15,12)  DEFAULT NULL,
             `ra1`  DECIMAL(15,12)  DEFAULT NULL,
            `dec1`  DECIMAL(15,12)  DEFAULT NULL,
             `ra2`  DECIMAL(15,12)  DEFAULT NULL,
            `dec2`  DECIMAL(15,12)  DEFAULT NULL,
             `ra3`  DECIMAL(15,12)  DEFAULT NULL,
            `dec3`  DECIMAL(15,12)  DEFAULT NULL,
             `ra4`  DECIMAL(15,12)  DEFAULT NULL,
            `dec4`  DECIMAL(15,12)  DEFAULT NULL,
           `magzp`    DECIMAL(7,5)  DEFAULT NULL,
        `magzpunc`    DECIMAL(7,6)  DEFAULT NULL,
          `fcdate`     VARCHAR(20)  DEFAULT NULL,
       `date_obs1`     VARCHAR(24)  DEFAULT NULL,
         `mid_obs`     VARCHAR(24)  DEFAULT NULL,
       `date_obs2`     VARCHAR(24)  DEFAULT NULL,
           `sizex`    DECIMAL(8,6)  DEFAULT NULL,
           `sizey`    DECIMAL(8,6)  DEFAULT NULL,
         `pxscal1`    DECIMAL(8,6)  DEFAULT NULL,
         `pxscal2`    DECIMAL(8,6)  DEFAULT NULL,
         `moonrej`             INT  DEFAULT NULL,
         `mooninp`             INT  DEFAULT NULL,
          `medint`    DECIMAL(8,3)  DEFAULT NULL,
          `medcov`    DECIMAL(8,3)  DEFAULT NULL,
          `mincov`    DECIMAL(8,3)  DEFAULT NULL,
          `maxcov`    DECIMAL(8,3)  DEFAULT NULL,
       `lowcovpc1`    DECIMAL(9,6)  DEFAULT NULL,
       `lowcovpc2`    DECIMAL(9,6)  DEFAULT NULL,
        `nomcovpc`    DECIMAL(9,6)  DEFAULT NULL,
        `mincovpc`    DECIMAL(9,6)  DEFAULT NULL,
          `robsig`   DECIMAL(13,6)  DEFAULT NULL,
        `pixchis1`   DECIMAL(10,6)  DEFAULT NULL,
        `pixchis2`   DECIMAL(10,6)  DEFAULT NULL,
         `mednmsk`    DECIMAL(9,1)  DEFAULT NULL,
          `cdelt1`  DECIMAL(19,18)  DEFAULT NULL,
          `cdelt2`  DECIMAL(19,18)  DEFAULT NULL,
          `crota2`  DECIMAL(16,13)  DEFAULT NULL,
         `bitmask`             INT  DEFAULT NULL,
         `numfrms`             INT  DEFAULT NULL,
      `qual_coadd`             INT  DEFAULT NULL,
         `qc_fact`    DECIMAL(2,1)  DEFAULT NULL,
         `qi_fact`    DECIMAL(2,1)  DEFAULT NULL,
         `qa_fact`    DECIMAL(2,1)  DEFAULT NULL,
    `date_imgprep`     VARCHAR(20)  DEFAULT NULL,
         `load_id`             INT  DEFAULT NULL,
            `cntr`          BIGINT  DEFAULT NULL

) ENGINE=MyISAM;
