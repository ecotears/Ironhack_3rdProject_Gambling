-- Pregunta 01
select Title, FirstName, LastName, Dateofbirth
from customer;

-- Pregunta 02
select count(custID) as num_clientes, Customergroup
from customer
group by customergroup;

-- Pregunta 03
select cust.*, currencycode
from customer cust
inner join account acc
on cust.custId = acc.CustId
;

-- Pregunta 04
select a.product, sum(ifnull(Bet_Amt,0)) as Dinero_Apostado, date(BetDate) as fecha
from product a
left join betting b
on a.ClassId = b.classID
group by a.product, fecha
order by fecha asc
;

-- Pregunta 05
select a.product, sum(ifnull(Bet_Amt,0)) as Dinero_Apostado, date(BetDate) as fecha
from product a
left join betting b
on a.ClassId = b.classID
where date(BetDate) >= '2012-11-01' and a.product = 'Sportsbook'
group by a.product, fecha
order by fecha asc
;

-- Pregunta 06
select a.product, b.currencycode, c.customergroup, sum(Dinero_Apostado) as Dinero_Apostado
from (select a.product, a.sub_product, b.accountno, ifnull(Bet_Amt,0) as Dinero_Apostado, date(BetDate) as fecha
from product a
left join betting b
on a.ClassId = b.classID
where date(BetDate) >= '2012-12-01') a
left join account b
on a.AccountNo = b.AccountNo
inner join customer c
on b.custid = c.custid
group by a.product, b.currencycode, c.customergroup;

-- Pregunta 07
select Title, FirstName, LastName, sum(ifnull(Bet_Amt,0)) as DineroApostado
from customer a
inner join account b
on a.custid = b.custid
left join 
(select Bet_Amt, accountno
from betting
where month(BetDate) = 11) c
on b.accountno = c.accountno
group by Title, FirstName, LastName;

-- Pregunta 08
select a.custid, ifnull(count(distinct(c.product)),0)
from customer a
inner join account b
on a.custid = b.custid
left join 
(select Accountno, d.product, sum(case when Bet_Amt > 0 then 1
else 0
end) Apostado_o_no
from betting c
inner join product d
on c.classid = d.classid
group by Accountno, d.product) c
on b.accountno = c.accountno
group by a.custid;

-- Segunda parte del 8
With temporary as (select a.custid, sum(case when c.product = 'Vegas' then 1
else 0
end) Vegas,
sum(case when c.product = 'Sportsbook' then 1
else 0
end) Sportsbook
from customer a
inner join account b
on a.custid = b.custid
left join 
(select Accountno, d.product, sum(case when Bet_Amt > 0 then 1
else 0
end) Apostado_o_no
from betting c
inner join product d
on c.classid = d.classid
group by Accountno, d.product) c
on b.accountno = c.accountno
group by custid)

select custid
from temporary
where Vegas + Sportsbook = 2;

-- Pregunta 09

select custid, sum(apostado), sum(Sportsbook), sum(Sportsbook + NotSportsbook)
from
(select custid, product, a.AccountNo, sum(Bet_Amt) as apostado, case when product != 'Sportsbook' then 1
else 0
end as NotSportsbook, case when product = 'Sportsbook' then 1
else 0
end as Sportsbook
from Betting b
inner join account a
on b.accountno = a.accountno
group by custid, product, AccountNo) temp
group by custid
having sum(Sportsbook) > 0 and (sum(Sportsbook + NotSportsbook) < 2);

-- Pregunta 10
select custid, product as favorite_product
from
(select CustId, b.product, ifnull(sum(Bet_Amt),0) as dinero_apostado, rank() over(partition by custid order by sum(Bet_Amt) desc) as ranking
from betting b
right join account a
on b.accountno = a.accountno
group by custid, b.product) temp
where ranking = 1;

-- Pregunta 11
select student_name, GPA
from student
order by GPA DESC
limit 5;

-- Pregunta 12
select school_name, count(student_id) as n_students
from school a
left join student b
on a.school_id = b.school_id
group by school_name;

-- Pregunta 13

select school_name, student_name, GPA
from
(select school_name, student_name, ifnull(GPA,0) as GPA, rank() over(partition by school_name order by GPA DESC) as rk
from school a
left join student b
on a.school_id = b.school_id) temp
where rk < 3;



