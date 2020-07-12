BENCH_DIR=benchspec
INST_LIMIT=100000000

usage () {
    cat <<HELP_USAGE

    $0  [-sd] -b <benchmark>

   -b --bench         The benchmark to run (gcc,bzip2,mcf)

   Please space seperate as much as passible
HELP_USAGE
}

BENCH_NAME=""
DEBUG_FLAGS=""
GEM5_EXE_NAME="gem5.opt"
ARCH="X86" # Use X86 by default
while [ "$1" != "" ]; do
    PARAM=$1
    VALUE=$2
    echo $PARAM $VALUE
    case $PARAM in
        -h | --help)
            usage
            exit 0
            ;;
        -b | --bench)
            BENCH_NAME=$VALUE
            shift
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

GEM5_EXE_PATH="build/$ARCH/$GEM5_EXE_NAME"

BZ2_DATA=$BENCH_DIR/'bzip2_data/all/input/input.program'
BZ2_ARG=1

GCC_DATA=$BENCH_DIR/'gcc_data/test/input/cccp.i'
GCC_OUT=$BENCH_DIR/'gcc_data/test/output/cccp.s'

MCF_DATA=$BENCH_DIR/'mcf_data/test/input/inp.in'

HMMER_DATA=$BENCH_DIR/'hmmer_data/test/input/bombesin.hmm'
HMMER_ARG='--fixed 0 --mean 325 --num 5000 --sd 200 --seed 0'

LIBQT_ARG='33 5'

GOBMK_DATA=$BENCH_DIR/'gobmk_data/test/input/capture.tst'
GOBMK_ARG='--quiet --mode gtp'

if [ "$BENCH_NAME" = 'gcc' ]
then
    $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-gcc -o "$GCC_DATA $GCC_OUT" > m5out/"gcc_$ARCH-$GEM5_EXE_NAME.out"
elif [ "$BENCH_NAME" = 'bzip2' ]
then
    $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-bzip2 -o "$BZ2_DATA $BZ2_ARG" > m5out/"bzip2_$ARCH-$GEM5_EXE_NAME.out"
elif [ "$BENCH_NAME" = 'mcf' ]
then
    $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-mcf -o "$MCF_DATA" > m5out/"mcf_$ARCH-$GEM5_EXE_NAME.out"
elif [ "$BENCH_NAME" = 'hmmer' ]
then
    $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-hmmer -o "$HMMER_ARG $HMMER_DATA" > m5out/"hmmer_$ARCH-$GEM5_EXE_NAME.out"
elif [ "$BENCH_NAME" = 'libquantum' ]
then
    $GEM5_EXE_PATH configs/example/se.py --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-libquantum -o "$LIBQT_ARG" > m5out/"libquantum_$ARCH-$GEM5_EXE_NAME.out"
elif [ "$BENCH_NAME" = 'gobmk' ]
then
    $GEM5_EXE_PATH configs/example/se.py --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-gobmk -o "$GOBMK_DATA $GOBMK_ARG" > m5out/"gobmk_$ARCH-$GEM5_EXE_NAME.out"
else
    echo "Running all benchmarks on background!"
    nohup $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-bzip2 -o "$BZ2_DATA $BZ2_ARG" > m5out/"bzip2_$ARCH-$GEM5_EXE_NAME.out" &
    sleep 1
    nohup $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-gcc -o "$GCC_DATA $GCC_OUT" > m5out/"gcc_$ARCH-$GEM5_EXE_NAME.out" &
    sleep 1
    nohup $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-mcf -o "$MCF_DATA" > m5out/"mcf_$ARCH-$GEM5_EXE_NAME.out" &
    sleep 1
    nohup $GEM5_EXE_PATH configs/example/se.py -I $INST_LIMIT --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-hmmer -o "$HMMER_DATA" > m5out/"hmmer_$ARCH-$GEM5_EXE_NAME.out" &
    sleep 1
 #   nohup $GEM5_EXE_PATH configs/example/se.py --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-libquantum -o "$LIBQT_ARG" > m5out/"libquantum_$ARCH-$GEM5_EXE_NAME.out" &
   # sleep 1
  #  nohup $GEM5_EXE_PATH configs/example/se.py --cpu-type=AtomicSimpleCPU --caches -c $BENCH_DIR/$ARCH-gobmk -o "$GOBMK_DATA $GOBMK_ARG" > m5out/"gobmk_$ARCH-$GEM5_EXE_NAME.out" &
fi

