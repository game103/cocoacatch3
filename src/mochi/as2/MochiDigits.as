class mochi.as2.MochiDigits
{
    var Encoder, __get__value, Fragment, Sibling, __set__value;
    function MochiDigits(digit, index)
    {
        Encoder = 0;
        this.setValue(digit, index);
    } // End of the function
    function get value()
    {
        return (Number(this.toString()));
    } // End of the function
    function set value(v)
    {
        this.setValue(v);
        //return (this.value());
        null;
    } // End of the function
    function addValue(v)
    {
        value = value + v;
    } // End of the function
    function setValue(digit, index)
    {
        var _loc3 = digit.toString();
        if (index == undefined || isNaN(index))
        {
            index = 0;
        } // end if
        Fragment = _loc3.charCodeAt(index++) ^ Encoder;
        if (index < _loc3.length)
        {
            Sibling = new mochi.as2.MochiDigits(digit, index);
        }
        else
        {
            Sibling = null;
        } // end else if
        this.reencode();
    } // End of the function
    function reencode()
    {
        var _loc2 = int(2147483647 * Math.random());
        Fragment = Fragment ^ (_loc2 ^ Encoder);
        Encoder = _loc2;
    } // End of the function
    function toString()
    {
        var _loc2 = String.fromCharCode(Fragment ^ Encoder);
        return (Sibling != null ? (_loc2.concat(Sibling.toString())) : (_loc2));
    } // End of the function
} // End of Class
