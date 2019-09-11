#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
export CROMWELL_BUILD_OPTIONAL_SECURE=true
# import in shellcheck / CI / IntelliJ compatible ways
# shellcheck source=/dev/null
source "${BASH_SOURCE%/*}/test.inc.sh" || source test.inc.sh

cromwell::build::setup_common_environment

CROMWELL_SBT_TEST_SPAN_SCALE_FACTOR=1

case "${CROMWELL_BUILD_PROVIDER}" in
    "${CROMWELL_BUILD_PROVIDER_TRAVIS}")
        CROMWELL_SBT_TEST_EXCLUDE_TAGS="AwsTest,CromwellIntegrationTest,GcsIntegrationTest"
        CROMWELL_SBT_TEST_SPAN_SCALE_FACTOR=2
        ;;
    "${CROMWELL_BUILD_PROVIDER_JENKINS}")
        CROMWELL_SBT_TEST_EXCLUDE_TAGS="AwsTest,CromwellIntegrationTest,DockerTest,GcsIntegrationTest"
        CROMWELL_SBT_TEST_SPAN_SCALE_FACTOR=10
        ;;
    *)
        # Use the full list of excludes listed in Testing.scala
        CROMWELL_SBT_TEST_EXCLUDE_TAGS=""
        ;;
esac
export CROMWELL_SBT_TEST_EXCLUDE_TAGS
export CROMWELL_SBT_TEST_SPAN_SCALE_FACTOR

CROMWELL_SBT_TEST_RESULT=0
sbt_test() {
    local test_result
    set +e
    sbt \
        -Dakka.test.timefactor=${CROMWELL_SBT_TEST_SPAN_SCALE_FACTOR} \
        -Dbackend.providers.Local.config.filesystems.local.localization.0=copy \
        coverage "${1?}/test"
    test_result=$?
    set -e
    if [[ ${test_result} -ne 0 ]]; then
        CROMWELL_SBT_TEST_RESULT=${test_result}
    fi
}

sbt coverage test:compile
sbt_test awsBackend
sbt_test awsS3FileSystem
sbt_test backend
sbt_test bcsBackend
sbt_test centaur
sbt_test centaurCwlRunner
sbt_test cloud-nio-impl-drs
sbt_test cloud-nio-impl-ftp
sbt_test cloud-nio-spi
sbt_test cloud-nio-util
sbt_test cloudSupport
sbt_test common
sbt_test core
sbt_test cromiam
sbt_test cromwell-drs-localizer
sbt_test cromwellApiClient
sbt_test cwl
sbt_test cwlEncoder
sbt_test cwlV1_0LanguageFactory
sbt_test databaseMigration
sbt_test databaseSql
sbt_test dockerHashing
sbt_test drsFileSystem
sbt_test engine
sbt_test ftpFileSystem
sbt_test gcsFileSystem
sbt_test googlePipelinesCommon
sbt_test googlePipelinesV1Alpha2
sbt_test googlePipelinesV2Alpha1
sbt_test httpFileSystem
sbt_test hybridCarboniteMetadataService
sbt_test jesBackend
sbt_test languageFactoryCore
sbt_test ossFileSystem
sbt_test perf
sbt_test server
sbt_test services
sbt_test sfsBackend
sbt_test sparkBackend
sbt_test sraFileSystem
sbt_test statsDProxy
sbt_test tesBackend
sbt_test wdlBiscayneLanguageFactory
sbt_test wdlDraft2LanguageFactory
sbt_test wdlDraft3LanguageFactory
sbt_test wdlModelBiscayne
sbt_test wdlModelDraft2
sbt_test wdlModelDraft3
sbt_test wdlNewBaseTransforms
sbt_test wdlSharedModel
sbt_test wdlSharedTransforms
sbt_test wdlTransformsBiscayne
sbt_test wdlTransformsDraft2
sbt_test wdlTransformsDraft3
sbt_test wes2cromwell
sbt_test wom
sbt_test womtool

if [[ ${CROMWELL_SBT_TEST_RESULT} -ne 0 ]]; then
    exit ${CROMWELL_SBT_TEST_RESULT}
fi

cromwell::build::generate_code_coverage

cromwell::build::publish_artifacts
