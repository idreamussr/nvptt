function Number2Words(number) {
    var s = number.toString();// number as string
    if (s != parseInt(s)) return 'not a number';
    if (x > 4) return 'NAN';

    // references
    var th = {1: 'тысяча', 2: 'тысячи', 3: 'тысячи', 4: 'тысячи', 5:'тысяч'};
    var dgt = {1: 'однa', 2: 'две'};
    var dg = {1:'один',2: 'два',3: 'три',4: 'четыре',5: 'пять',6: 'шесть',7: 'семь',8: 'восемь',9: 'девять'};
    var tn = ['десять', 'одинадцать', 'двенадцать', 'тринадцать', 'четырнадцать', 'пятнадцать', 'шестнадцать', 'семнадцать', 'восемнадцать', 'девятнадцать'];
    var tw = ['двадцать', 'тридцать', 'сорок', 'пятдесяц', 'шестьдесяц', 'семьдесят', 'восемдесят', 'девяносто'];
    var ts = {1: 'сто',2: 'двести',3: 'триста',4: 'четыреста',5: 'пятьсот',6: 'шестьсот',7: 'семьсот',8: 'восемьсот',9: 'девятьсот'};

    // working vars
    var str = '';// result string
    var x = s.length;// number length
    var n = s.split('');
    var pos = 0; // stores current position
    for (var i = 0; i < x; i++) {
        pos = x-i;
        if(pos % 3 == 2) {
            if (n[i] == '1') {
                // teens
                str += tn[Number(n[i + 1])] + ' ';
                i++;
            } else if (n[i] != 0) {
                str += tw[n[i] - 2] + ' ';
            }
        } else if (n[i] != 0) {
            if(pos == 1) {
                str += dg[n[i]] + ' ';
            } else if (pos == 4) {
                str += ((n[i] < 3)?dgt[n[i]]:dg[n[i]]) + ' ';
            } else {
                str += ts[n[i]] + ' ';
            }
        }
        if (pos>3) {
            str += ((n[i]>5)?th[5]:th[n[i]]) + ' ';
        }

    }
    return str.replace(/\s+/g, ' ');
};