import os

# toolchains options
ARCH        ='risc-v'
VENDOR      ='t-head'
CPU         ='c906'
CROSS_TOOL  ='gcc'

if os.getenv('RTT_ROOT'):
    RTT_ROOT = os.getenv('RTT_ROOT')
else:
    RTT_ROOT = r'../../..'

if os.getenv('RTT_CC'):
    CROSS_TOOL = os.getenv('RTT_CC')

if  CROSS_TOOL == 'gcc':
    PLATFORM    = 'gcc'
    EXEC_PATH   = r'/opt/Xuantie-900-gcc-elf-newlib-x86_64-V2.8.1/bin'
else:
    print('Please make sure your toolchains is GNU GCC!')
    exit(0)

if os.getenv('RTT_EXEC_PATH'):
    EXEC_PATH = os.getenv('RTT_EXEC_PATH')

BUILD = 'debug'
CHIP_TYPE = 'cv181x'

if PLATFORM == 'gcc':
    # toolchains
    #PREFIX  = 'riscv64-unknown-elf-'
    PREFIX  = os.getenv('RTT_CC_PREFIX') or 'riscv64-unknown-elf-'
    CC      = PREFIX + 'gcc'
    CXX     = PREFIX + 'g++'
    AS      = PREFIX + 'gcc'
    AR      = PREFIX + 'ar'
    LINK    = PREFIX + 'gcc'
    TARGET_EXT = 'elf'
    SIZE    = PREFIX + 'size'
    OBJDUMP = PREFIX + 'objdump'
    OBJCPY  = PREFIX + 'objcopy'

    DEVICE  = ' -mcmodel=medany -march=rv64imafdc -mabi=lp64'
    CFLAGS  = DEVICE + ' -Wno-cpp -fvar-tracking -ffreestanding -fno-common -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -D_POSIX_SOURCE '
    AFLAGS  = ' -c' + DEVICE + ' -x assembler-with-cpp -D__ASSEMBLY__'
    LFLAGS  = DEVICE + ' -nostartfiles -Wl,--gc-sections,-Map=rtthread.map,-cref,-u,_start -T link.lds' + ' -lsupc++ -lgcc -static'
    CPATH   = ''
    LPATH   = ''

    if BUILD == 'debug':
        CFLAGS += ' -O0 -ggdb'
        AFLAGS += ' -ggdb'
    else:
        CFLAGS += ' -O2 -Os'

    CXXFLAGS = CFLAGS

SCRIPT_DIR = os.getenv('DUO_SCRIPT_DIR')

BKERNEL_PATH = os.getenv('RT_DUO_BKERNEL')

current = os.path.abspath(__file__)
current_dir = os.path.dirname(current)

DUMP_ACTION = OBJDUMP + ' -D -S $TARGET > rtthread.asm\n'
POST_ACTION = OBJCPY + ' -O binary $TARGET rtthread.bin \n' + SIZE + ' $TARGET \n'

if BKERNEL_PATH is None:
	if SCRIPT_DIR is None:
		POST_ACTION += 'echo "## please source env.sh firstly and check the RTT_ROOT" \n'
	else:
		POST_ACTION += 'bash ' + SCRIPT_DIR + '/rt_env.sh ' + current_dir + ' bcore \n'
else:	
	if os.path.normpath(BKERNEL_PATH) != os.path.normpath(current_dir):
		if SCRIPT_DIR is None:
			POST_ACTION += 'echo "## please source env.sh firstly and check the RTT_ROOT" \n'
		else:
			POST_ACTION += 'bash ' + SCRIPT_DIR + '/rt_env.sh ' + current_dir + ' bcore \n'





