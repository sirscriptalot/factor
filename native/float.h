typedef struct {
	CELL header;
	double n;
} F_FLOAT;

INLINE F_FLOAT* make_float(double n)
{
	F_FLOAT* flo = allot_object(FLOAT_TYPE,sizeof(F_FLOAT));
	flo->n = n;
	return flo;
}

INLINE double untag_float_fast(CELL tagged)
{
	return ((F_FLOAT*)UNTAG(tagged))->n;
}

INLINE double untag_float(CELL tagged)
{
	type_check(FLOAT_TYPE,tagged);
	return untag_float_fast(tagged);
}

double to_float(CELL tagged);
void primitive_to_float(void);
void primitive_str_to_float(void);
void primitive_float_to_str(void);
void primitive_float_to_bits(void);

void primitive_float_eq(void);
void primitive_float_add(void);
void primitive_float_subtract(void);
void primitive_float_multiply(void);
void primitive_float_divfloat(void);
void primitive_float_less(void);
void primitive_float_lesseq(void);
void primitive_float_greater(void);
void primitive_float_greatereq(void);

void primitive_facos(void);
void primitive_fasin(void);
void primitive_fatan(void);
void primitive_fatan2(void);
void primitive_fcos(void);
void primitive_fexp(void);
void primitive_fcosh(void);
void primitive_flog(void);
void primitive_fpow(void);
void primitive_fsin(void);
void primitive_fsinh(void);
void primitive_fsqrt(void);
