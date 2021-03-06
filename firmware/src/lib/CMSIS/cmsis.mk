
CMSIS_INC = -I$(CMSIS)/DSP/Include \
            -I$(CMSIS)/Device/ST/STM32L4xx/Include \
            -I$(CMSIS)/Core/Include

CMSIS_ASMSRC = $(CMSIS)/DSP/Source/TransformFunctions/arm_bitreversal2.S

CMSIS_LIBDIR = 
CMSIS_LIB = 

CMSIS_CSRC =
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_shift_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_mult_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_copy_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_init_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_init_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/CommonTables/arm_const_structs.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/CommonTables/arm_common_tables.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_sqrt_q31.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_q31.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_q31.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_f32.c

# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_sub_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_add_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_mult_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_scale_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_trans_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_add_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_sub_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_inverse_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_cmplx_mult_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_trans_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_scale_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_mult_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_add_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_cmplx_mult_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_scale_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_trans_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_mult_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_sub_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_mult_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_cmplx_mult_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/MatrixFunctions/arm_mat_inverse_f64.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_q15.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_fast_f32.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_fast_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_bitreversal.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_init_f32.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_f32.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_rfft_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_dct4_q31.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix8_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix4_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/TransformFunctions/arm_cfft_radix2_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df2T_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_32x64_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_init_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_init_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_stereo_df2T_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_fast_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df2T_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_opt_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_fast_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_stereo_df2T_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df2T_f64.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_interpolate_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df2T_init_f64.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_fast_opt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_32x64_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_fast_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_opt_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_lattice_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_iir_lattice_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_fast_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_sparse_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_fir_decimate_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_lms_norm_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_biquad_cascade_df1_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_correlate_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FilteringFunctions/arm_conv_partial_opt_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_power_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_mean_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_var_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_std_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_power_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_rms_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_mean_f32.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_var_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_power_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_rms_q31.c
CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_max_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_std_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_power_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_mean_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_rms_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_min_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_std_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_mean_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/StatisticsFunctions/arm_var_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_sub_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_add_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_abs_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_mult_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_negate_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_sub_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_scale_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_offset_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_scale_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_add_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_offset_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_sub_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_mult_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_abs_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_shift_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_dot_prod_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_offset_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_scale_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_dot_prod_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_sub_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_negate_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_dot_prod_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_negate_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_abs_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_scale_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_shift_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_add_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_mult_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_mult_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_abs_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_dot_prod_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_negate_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_add_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/BasicMathFunctions/arm_offset_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q31_to_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_fill_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_float_to_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_copy_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_fill_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q7_to_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q15_to_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q31_to_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_fill_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q31_to_float.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_float_to_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_copy_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q7_to_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q15_to_float.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_copy_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q15_to_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_fill_q7.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_float_to_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/SupportFunctions/arm_q7_to_float.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_init_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_sin_cos_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_sin_cos_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_reset_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_init_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_reset_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_init_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ControllerFunctions/arm_pid_reset_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_sin_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_cos_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_cos_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_sqrt_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_cos_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_sin_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/FastMathFunctions/arm_sin_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_squared_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_cmplx_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_dot_prod_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_real_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_conj_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_squared_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_real_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_cmplx_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_squared_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_cmplx_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_dot_prod_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_conj_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mag_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_mult_real_q15.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_dot_prod_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Source/ComplexMathFunctions/arm_cmplx_conj_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_class_marks_example/GCC/arm_class_marks_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_class_marks_example/GCC/Startup/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_class_marks_example/GCC/Startup/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_class_marks_example/GCC/Startup/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_class_marks_example/ARM/arm_class_marks_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/GCC/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/GCC/arm_convolution_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/GCC/Startup/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/GCC/Startup/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/GCC/Startup/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_convolution_example/ARM/arm_convolution_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_signal_converge_example/ARM/arm_signal_converge_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_signal_converge_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_signal_converge_example/ARM/arm_signal_converge_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_linear_interp_example/ARM/arm_linear_interp_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_linear_interp_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_linear_interp_example/ARM/arm_linear_interp_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_sin_cos_example/ARM/arm_sin_cos_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_graphic_equalizer_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_graphic_equalizer_example/ARM/arm_graphic_equalizer_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_graphic_equalizer_example/ARM/arm_graphic_equalizer_example_q31.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_variance_example/ARM/arm_variance_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_dotproduct_example/GCC/arm_dotproduct_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_dotproduct_example/GCC/Startup/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_dotproduct_example/GCC/Startup/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_dotproduct_example/GCC/Startup/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_dotproduct_example/ARM/arm_dotproduct_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_matrix_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_matrix_example/ARM/arm_matrix_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fir_example/ARM/math_helper.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fir_example/ARM/arm_fir_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fir_example/ARM/arm_fir_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/GCC/arm_fft_bin_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/GCC/arm_fft_bin_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/GCC/Startup/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/GCC/Startup/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/GCC/Startup/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/ARM/arm_fft_bin_example_f32.c
# CMSIS_CSRC +=	$(CMSIS)/DSP/Examples/arm_fft_bin_example/ARM/arm_fft_bin_data.c
# CMSIS_CSRC +=	$(CMSIS)/DSP)/Device/ST/STM32L4xx/Source/Templates/system_stm32l4xx.c


CMSIS_INC  += -I$(CMSIS)/NN/Include
CMSIS_CSRC +=	$(CMSIS)/NN/Source/PoolingFunctions/arm_avgpool_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/PoolingFunctions/arm_pool_q7_HWC.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/PoolingFunctions/arm_max_pool_s8_opt.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/PoolingFunctions/arm_max_pool_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_add_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_depthwise_conv_nt_t_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_q7_to_q15_reordered_no_shift.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_mult_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_q7_to_q15_reordered_with_offset.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_mat_mul_core_1x_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_vec_mat_mult_t_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_depthwise_conv_nt_t_padded_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nntables.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_mat_mul_core_4x_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_mat_mult_nt_t_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_q7_to_q15_no_shift.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_accumulate_q7_to_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_nn_mult_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/NNSupportFunctions/arm_q7_to_q15_with_offset.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_mat_q7_vec_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_q15_opt.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_q7_opt.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/FullyConnectedFunctions/arm_fully_connected_mat_q7_vec_q15_opt.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConcatenationFunctions/arm_concatenation_s8_x.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConcatenationFunctions/arm_concatenation_s8_w.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConcatenationFunctions/arm_concatenation_s8_y.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConcatenationFunctions/arm_concatenation_s8_z.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/SoftmaxFunctions/arm_softmax_u8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/SoftmaxFunctions/arm_softmax_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/SoftmaxFunctions/arm_softmax_with_batch_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/SoftmaxFunctions/arm_softmax_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/SoftmaxFunctions/arm_softmax_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ActivationFunctions/arm_relu_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ActivationFunctions/arm_relu6_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ActivationFunctions/arm_nn_activations_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ActivationFunctions/arm_nn_activations_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ActivationFunctions/arm_relu_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/BasicMathFunctions/arm_elementwise_add_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/BasicMathFunctions/arm_elementwise_mul_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_basic.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_q7_q15.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_1x1_s8_fast.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_conv_3x3_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_basic.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_separable_conv_HWC_q7_nonsquare.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_basic_nonsquare.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_depthwise_conv_s8_core.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_fast.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_1_x_n_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_fast_nonsquare.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_RGB.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_1x1_HWC_q7_fast_nonsquare.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_conv_u8_basic_ver1.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_conv_s8_opt.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_conv_s8.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_s8_s16_reordered.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_fast_nonsquare.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_depthwise_separable_conv_HWC_q7.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_s8_s16.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_fast.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_q7_q15_reordered.c
CMSIS_CSRC +=	$(CMSIS)/NN/Source/ReshapeFunctions/arm_reshape_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8/TestRunner/test_arm_depthwise_conv_s8_runner.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8/Unity/unity_test_arm_depthwwise_conv_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8/test_arm_depthwise_conv_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_max_pool_s8_opt/Unity/unity_test_arm_max_pool_s8_opt.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_max_pool_s8_opt/test_arm_max_pool_s8_opt.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_convolve_s8/Unity/unity_test_arm_convolve_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_convolve_s8/test_arm_convolve_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8_opt/TestRunner/test_arm_depthwise_conv_s8_opt_runner.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8_opt/Unity/unity_test_arm_depthwise_conv_s8_opt.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_depthwise_conv_s8_opt/test_arm_depthwise_conv_s8_opt.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_convolve_1x1_s8_fast/Unity/unity_test_arm_convolve_1x1_s8_fast.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_convolve_1x1_s8_fast/test_arm_convolve_1x1_s8_fast.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_avgpool_s8/Unity/unity_test_arm_avgpool_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Tests/UnitTest/TestCases/test_arm_avgpool_s8/test_arm_avgpool_s8.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/gru/RTE/Device/ARMCM7_SP/startup_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/gru/RTE/Device/ARMCM7_SP/system_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/gru/RTE/Device/ARMCM0/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/gru/RTE/Device/ARMCM4_FP/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/gru/RTE/Device/ARMCM3/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/cifar10/RTE/Device/ARMCM7_SP/startup_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/cifar10/RTE/Device/ARMCM7_SP/system_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/cifar10/RTE/Device/ARMCM0/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/cifar10/RTE/Device/ARMCM4_FP/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/NN/Examples/ARM/arm_nn_examples/cifar10/RTE/Device/ARMCM3/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM7_SP/startup_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM7_SP/system_ARMCM7.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM0/system_ARMCM0.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM4_FP/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/STM32F411RETx/system_stm32f4xx.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM4/system_ARMCM4.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/RTE/Device/ARMCM3/system_ARMCM3.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_nn_mult_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_convolve_HWC_q7_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_depthwise_separable_conv_HWC_q7_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_depthwise_separable_conv_HWC_q7_ref_nonsquare.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_pool_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_mat_q7_vec_q15_opt_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_convolve_HWC_q15_ref_nonsquare.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_q7_opt_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_convolve_HWC_q15_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_relu_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_convolve_HWC_q7_ref_nonsquare.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_q15_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_q7_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_q15_opt_ref.c
# CMSIS_CSRC +=	$(CMSIS)/NN/NN_Lib_Tests/nn_test/Ref_Implementations/arm_fully_connected_mat_q7_vec_q15_ref.c
