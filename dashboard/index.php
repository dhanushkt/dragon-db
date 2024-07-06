<!doctype html>
<html lang="en">

<head>
    <?php require_once 'global/head.php'; ?>
</head>

<body>

    <div id="page-container"
        class="sidebar-o sidebar-dark enable-page-overlay side-scroll page-header-fixed main-content-narrow">


        <!-- Sidebar -->
        <?php require_once 'global/sidebar.php'; ?>
        <!-- END Sidebar -->

        <!-- Header -->
        <?php require_once 'global/header.php'; ?>
        <!-- END Header -->

        <!-- Main Container -->
        <main id="main-container">
            <!-- Hero -->
            <div class="content">
                <div
                    class="d-md-flex justify-content-md-between align-items-md-center py-3 pt-md-3 pb-md-0 text-center text-md-start">
                    <div>
                        <h1 class="h3 mb-1">
                            Dashboard
                        </h1>
                        <p class="fw-medium mb-0 text-muted">
                            Welcome to Dragon DB, admin!
                        </p>
                    </div>
                    <div class="mt-4 mt-md-0">
                        <a class="btn btn-sm btn-alt-primary" href="javascript:void(0)">
                            <i class="fa fa-cog"></i>
                        </a>
                        <div class="dropdown d-inline-block">
                            <button type="button" class="btn btn-sm btn-alt-primary px-3"
                                id="dropdown-analytics-overview" data-bs-toggle="dropdown" aria-haspopup="true"
                                aria-expanded="false">
                                Last 30 days <i class="fa fa-fw fa-angle-down"></i>
                            </button>
                            <div class="dropdown-menu dropdown-menu-end fs-sm"
                                aria-labelledby="dropdown-analytics-overview">
                                <a class="dropdown-item" href="javascript:void(0)">This Week</a>
                                <a class="dropdown-item" href="javascript:void(0)">Previous Week</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="javascript:void(0)">This Month</a>
                                <a class="dropdown-item" href="javascript:void(0)">Previous Month</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END Hero -->

            <!-- Page Content -->
            <div class="content">
                <!-- Overview -->
                <div class="row items-push">
                    <div class="col-sm-6 col-xl-3">
                        <div class="block block-rounded text-center d-flex flex-column h-100 mb-0">
                            <div class="block-content block-content-full flex-grow-1">
                                <div class="item rounded-3 bg-body mx-auto my-3">
                                    <i class="fa fa-users fa-lg text-primary"></i>
                                </div>
                                <div class="fs-1 fw-bold">2,388</div>
                                <div class="text-muted mb-3">Registered Users</div>
                                <div
                                    class="d-inline-block px-3 py-1 rounded-pill fs-sm fw-semibold text-success bg-success-light">
                                    <i class="fa fa-caret-up me-1"></i>
                                    19.2%
                                </div>
                            </div>
                            <div class="block-content block-content-full block-content-sm bg-body-light fs-sm">
                                <a class="fw-medium" href="javascript:void(0)">
                                    View all users
                                    <i class="fa fa-arrow-right ms-1 opacity-25"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="block block-rounded text-center d-flex flex-column h-100 mb-0">
                            <div class="block-content block-content-full flex-grow-1">
                                <div class="item rounded-3 bg-body mx-auto my-3">
                                    <i class="fa fa-level-up-alt fa-lg text-primary"></i>
                                </div>
                                <div class="fs-1 fw-bold">14.6%</div>
                                <div class="text-muted mb-3">Media Added Rate</div>
                                <div
                                    class="d-inline-block px-3 py-1 rounded-pill fs-sm fw-semibold text-danger bg-danger-light">
                                    <i class="fa fa-caret-down me-1"></i>
                                    2.3%
                                </div>
                            </div>
                            <div class="block-content block-content-full block-content-sm bg-body-light fs-sm">
                                <a class="fw-medium" href="javascript:void(0)">
                                    Explore analytics
                                    <i class="fa fa-arrow-right ms-1 opacity-25"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="block block-rounded text-center d-flex flex-column h-100 mb-0">
                            <div class="block-content block-content-full flex-grow-1">
                                <div class="item rounded-3 bg-body mx-auto my-3">
                                    <i class="fa fa-chart-line fa-lg text-primary"></i>
                                </div>
                                <div class="fs-1 fw-bold">386</div>
                                <div class="text-muted mb-3">New Media Files</div>
                                <div
                                    class="d-inline-block px-3 py-1 rounded-pill fs-sm fw-semibold text-success bg-success-light">
                                    <i class="fa fa-caret-up me-1"></i>
                                    7.9%
                                </div>
                            </div>
                            <div class="block-content block-content-full block-content-sm bg-body-light fs-sm">
                                <a class="fw-medium" href="javascript:void(0)">
                                    View all media
                                    <i class="fa fa-arrow-right ms-1 opacity-25"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="block block-rounded text-center d-flex flex-column h-100 mb-0">
                            <div class="block-content block-content-full">
                                <div class="item rounded-3 bg-body mx-auto my-3">
                                    <i class="fa fa-wallet fa-lg text-primary"></i>
                                </div>
                                <div class="fs-1 fw-bold">$4,920</div>
                                <div class="text-muted mb-3">Total Subscriptions</div>
                                <div
                                    class="d-inline-block px-3 py-1 rounded-pill fs-sm fw-semibold text-danger bg-danger-light">
                                    <i class="fa fa-caret-down me-1"></i>
                                    0.3%
                                </div>
                            </div>
                            <div class="block-content block-content-full block-content-sm bg-body-light fs-sm">
                                <a class="fw-medium" href="javascript:void(0)">
                                    Subscription manager
                                    <i class="fa fa-arrow-right ms-1 opacity-25"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END Overview -->

            </div>
            <!-- END Page Content -->
        </main>
        <!-- END Main Container -->

        <!-- Footer -->
        <?php require_once 'global/footer.php'; ?>
        <!-- END Footer -->
    </div>
    <!-- END Page Container -->

    <?php require_once 'global/scripts.php'; ?>
</body>

</html>