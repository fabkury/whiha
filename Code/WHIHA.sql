/* WHIHA
 * Wireless Health In HIMSS Analytics (c)
 * ------
 * By Raymonde Uy, MD, MBA, and Fabricio Kury, MD, Paul Fontelo, MD, MPH
 * http://github.com/fabkury
 * Project start: May 2015.
 */

/* Figure 1 - Graph showing increasing annual adoption of hospital-wide wireless coverage from 2005 to 2012. */
SELECT 2012 as Year, N, round(N*100/TotalN, 3) as PercentN, TotalN
from (select count(*) as N from (select distinct HAEntityId from Wireless where IsWLAN = -1)) a,
	(select count(*) as TotalN from (select distinct HAEntityId from Wireless)) b;
/* Figure 1 respondents */
select count(*) as TotalN from (select distinct HAEntityId from Wireless);


/* Figure 2: Availability of WLAN in different hospital areas. */
select 2012 as Year, Location, N, round(N*100/TotalN, 3) as PercentN, TotalN
from (SELECT Location, count(HAEntityId) as N from WirelessAccess group by Location) a,
	(SELECT count(*) as TotalN from (select distinct HAEntityId from WirelessAccess)) b
order by N desc;
/* Figure 2 respondents */
SELECT count(*) as TotalN from (select distinct HAEntityId from WirelessAccess);


/* Figure 3: Percent of physicians using handhelds in hospitals. */
SELECT 2012 as Year, a.*, round(N*100/b.TotalN, 3) as PercentN, b.TotalN
from (select switch(
		HandHeldPerc=0, '0',
		HandHeldPerc<25,'1-24',
		HandHeldPerc<50,'25-49',
		HandHeldPerc<75,'50-74',
		HandHeldPerc>75,'75-100',
		true,'?') as HandHeldPercGroup,
		count(*) as N
	from Wireless
	where switch(
		HandHeldPerc=0, '0',
		HandHeldPerc<25,'1-24',
		HandHeldPerc<50,'25-49',
		HandHeldPerc<75,'50-74',
		HandHeldPerc>75,'75-100',
		true,'?') <> '?'
	group by switch(
		HandHeldPerc=0, '0',
		HandHeldPerc<25,'1-24',
		HandHeldPerc<50,'25-49',
		HandHeldPerc<75,'50-74',
		HandHeldPerc>75,'75-100',
	true,'?')) a,
(select count(*) as TotalN
	FROM Wireless
	where switch(
		HandHeldPerc=0, '0',
		HandHeldPerc<25,'1-24',
		HandHeldPerc<50,'25-49',
		HandHeldPerc<75,'50-74',
		HandHeldPerc>75,'75-100',
	true,'?') <> '?') b;
/* Figure 3 respondents */
select count(*) as Respondents
FROM Wireless
where switch(
	HandHeldPerc=0, '0',
	HandHeldPerc<25,'1-24',
	HandHeldPerc<50,'25-49',
	HandHeldPerc<75,'50-74',
	HandHeldPerc>75,'75-100',
true,'?') <> '?';


/* Figure 4: Please see whiha.R. */ 
/* Figure 4 respondents */
SELECT count(*) as Respondents from
(select distinct HAEntityId from HandheldInfo
	where (Value not like '*bar*coding*') and (Value not like '*others*'));

/* Figures 5 and 6: Hospital respondents per medical device type in year 2012; EMR Connection Types per Medical Device in year 2012. */
select 2012 as Year, c.DeviceType, c.ValueName, N, TotalN, round(N*100/TotalN, 3) as PercentN from
(select DeviceType, ValueName, count(*) as N
	from MedicalDeviceInterface a, MedicalDeviceInfo b
	where a.DeviceID=b.DeviceID and ValueName LIKE '*wire*'
	group by DeviceType, ValueName) c,
(select DeviceType, count(*) as TotalN
	from MedicalDeviceInterface a, MedicalDeviceInfo b
	where a.DeviceID=b.DeviceID and ValueName LIKE '*wire*'
	group by DeviceType) d
where c.DeviceType=d.DeviceType;
/* Figure 5 and 6 respondents */ 
select count(*) as Respondents from
(select distinct a.HAEntityId
	from MedicalDeviceInterface a, MedicalDeviceInfo b
	where a.DeviceID=b.DeviceID and ValueName LIKE '*wire*');


/* Figure 7 */
/* See "respondents" query after the query for each figure listed here. */