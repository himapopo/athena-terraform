CREATE EXTERNAL TABLE `${athena_database_name}.waf_logs`(
  `timestamp` bigint,
  `formatversion` int,
  `webaclid` string,
  `terminatingruleid` string,
  `terminatingruletype` string,
  `action` string,
  `terminatingrulematchdetails` array <
                                    struct <
                                        conditiontype: string,
                                        sensitivitylevel: string,
                                        location: string,
                                        matcheddata: array < string >
                                          >
                                     >,
  `httpsourcename` string,
  `httpsourceid` string,
  `rulegrouplist` array <
                      struct <
                          rulegroupid: string,
                          terminatingrule: struct <
                                              ruleid: string,
                                              action: string,
                                              rulematchdetails: array <
                                                                   struct <
                                                                       conditiontype: string,
                                                                       sensitivitylevel: string,
                                                                       location: string,
                                                                       matcheddata: array < string >
                                                                          >
                                                                    >
                                                >,
                          nonterminatingmatchingrules: array <
                                                              struct <
                                                                  ruleid: string,
                                                                  action: string,
                                                                  overriddenaction: string,
                                                                  rulematchdetails: array <
                                                                                       struct <
                                                                                           conditiontype: string,
                                                                                           sensitivitylevel: string,
                                                                                           location: string,
                                                                                           matcheddata: array < string >
                                                                                              >
                                                                   >,
                                                                  challengeresponse: struct <
                                                                            responsecode: string,
                                                                            solvetimestamp: string
                                                                              >,
                                                                  captcharesponse: struct <
                                                                            responsecode: string,
                                                                            solvetimestamp: string
                                                                              >
                                                                    >
                                                             >,
                          excludedrules: string
                            >
                       >,
`ratebasedrulelist` array <
                         struct <
                             ratebasedruleid: string,
                             limitkey: string,
                             maxrateallowed: int
                               >
                          >,
  `nonterminatingmatchingrules` array <
                                    struct <
                                        ruleid: string,
                                        action: string,
                                        rulematchdetails: array <
                                                             struct <
                                                                 conditiontype: string,
                                                                 sensitivitylevel: string,
                                                                 location: string,
                                                                 matcheddata: array < string >
                                                                    >
                                                             >,
                                        challengeresponse: struct <
                                                            responsecode: string,
                                                            solvetimestamp: string
                                                             >,
                                        captcharesponse: struct <
                                                            responsecode: string,
                                                            solvetimestamp: string
                                                             >
                                          >
                                     >,
  `requestheadersinserted` array <
                                struct <
                                    name: string,
                                    value: string
                                      >
                                 >,
  `responsecodesent` string,
  `httprequest` struct <
                    clientip: string,
                    country: string,
                    headers: array <
                                struct <
                                    name: string,
                                    value: string
                                      >
                                 >,
                    uri: string,
                    args: string,
                    httpversion: string,
                    httpmethod: string,
                    requestid: string
                      >,
  `labels` array <
               struct <
                   name: string
                     >
                >,
  `captcharesponse` struct <
                        responsecode: string,
                        solvetimestamp: string,
                        failureReason: string
                          >,
  `challengeresponse` struct <
                        responsecode: string,
                        solvetimestamp: string,
                        failureReason: string
                        >,
  `ja3Fingerprint` string
)
PARTITIONED BY ( 
`year` int, 
`month` int, 
`day` int) 
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://waf-block-log-himapopo/'
TBLPROPERTIES(
  'projection.enabled'='true', 

  'projection.day.digits'='2', 
  'projection.day.interval'='1', 
  'projection.day.range'='1,31', 
  'projection.day.type'='integer',
  
  'projection.month.digits'='2', 
  'projection.month.interval'='1', 
  'projection.month.range'='1,12', 
  'projection.month.type'='integer', 
  
  'projection.year.digits'='4', 
  'projection.year.interval'='1', 
  'projection.year.range'='2024,2030', 
  'projection.year.type'='integer',
  
 'storage.location.template' = 's3://waf-block-log-himapopo/year=$${year}/month=$${month}/day=$${day}')